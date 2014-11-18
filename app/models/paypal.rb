class Paypal
  module PAYMENT
    module STATUS
      CREATED = 'created'
      APPROVED = 'approved'
      PENDING = 'pending'
      COMPLETED = 'Completed'
      REFUNDED = 'Refunded'
    end
  end

  module IPN
    ACK_VERIFIED = "VERIFIED"
    ADDRESS_CONFIRMED = 'confirmed'

    class Notification < OpenStruct

    def send_ack_response(params)
      require "net/http"
      require "uri"

      uri = URI.parse(ENV["PAYPAL_ACK_URL"])

      response = Net::HTTP.post_form(uri, params)

      response.body
    end

      # Parameters: {
      # "residence_country"=>"US", "invoice"=>"abc1234", "address_city"=>"San Jose",
      # "first_name"=>"John", "payer_id"=>"TESTBUYERID01", "mc_fee"=>"0.44",
      # "txn_id"=>"860400748", "receiver_email"=>"seller@paypalsandbox.com",
      # "custom"=>"xyz123", "payment_date"=>"08:30:48 25 Jun 2014 PDT",
      # "address_country_code"=>"US", "address_zip"=>"95131", "item_name1"=>"something",
      # "mc_handling"=>"2.06", "mc_handling1"=>"1.67", "tax"=>"2.02",
      # "address_name"=>"John Smith", "last_name"=>"Smith",
      # "receiver_id"=>"seller@paypalsandbox.com",
      # "verify_sign"=>"AFcWxV21C7fd0v3bYYYRCpSSRl31AcNCdfeqI0JxyFUaHtDqDnxlaiv-",
      # "address_country"=>"United States", "payment_status"=>"Completed",
      # "address_status"=>"confirmed", "business"=>"seller@paypalsandbox.com",
      # "payer_email"=>"buyer@paypalsandbox.com", "notify_version"=>"2.4", "txn_type"=>"cart",
      # "test_ipn"=>"1", "payer_status"=>"unverified", "mc_currency"=>"USD", "mc_gross"=>"12.34",
      # "mc_shipping"=>"3.02", "mc_shipping1"=>"1.02", "item_number1"=>"AK-1234",
      # "address_state"=>"CA", "mc_gross1"=>"9.34", "payment_type"=>"instant",
      # "address_street"=>"123, any street", "subscription_id"=>"12"}
      # Completed 401 Unauthorized in 22ms

      # Rimborso
        # Parameters: {"mc_gross"=>"-27.00", "protection_eligibility"=>"Eligible", "payer_id"=>"UVVKT8RKRWMDU", "address_street"=>"Via Unit\u001A d'Italia, 5783296", "payment_date"=>"23:44:43 Nov 10, 2014 PST", "payment_status"=>"Refunded", "charset"=>"windows-1252", "address_zip"=>"80127", "first_name"=>"Ciccio", "mc_fee"=>"-0.92", "address_country_code"=>"IT", "address_name"=>"Ciccio Pasticcio", "notify_version"=>"3.8", "reason_code"=>"refund", "custom"=>"", "address_country"=>"Italy", "address_city"=>"Napoli", "verify_sign"=>"AAh-gjn1ENnDuooduWNAFaW4Pdn0AIv5RYJHyZ0rKvwQb8xV6S3idNHj", "payer_email"=>"ciccio.pasticcio@gmail.com", "parent_txn_id"=>"32353901J5444105S", "txn_id"=>"98A20060EK600694F", "payment_type"=>"instant", "last_name"=>"Pasticcio", "address_state"=>"NAPOLI", "receiver_email"=>"fabio.petrucci-facilitator@gmail.com", "payment_fee"=>"", "receiver_id"=>"CH3S8Q77P8WHN", "item_name"=>"Paperclip Single: sottoscrizione piano trimestrale \x80 27.00", "mc_currency"=>"EUR", "item_number"=>"", "residence_country"=>"IT", "test_ipn"=>"1", "handling_amount"=>"0.00", "transaction_subject"=>"", "payment_gross"=>"", "shipping"=>"0.00", "ipn_track_id"=>"e282e41e67268"}

      def verify!(subscription)
        completed = false

        begin
          subscription.state = payment_status

          # if address_status != Paypal::IPN::ADDRESS_CONFIRMED
          #   subscription.error = { message: "Indirizzo non confermato.", ipn: self.inspect }
          #   return false
          # end

          if receiver_email != ENV["PAYPAL_OWNER_EMAIL"]
            subscription.info = "Indirizzo venditore errato."
            return false
          end

          if txn_id != subscription.paypal_txn_id
            subscription.info = "Transazione non valida."
            return false
          end

          case payment_status
          # when Paypal::PAYMENT::STATUS::REFUNDED
          #   subscription.info = "Rimborso pagamento."
          #   completed = false
          when Paypal::PAYMENT::STATUS::COMPLETED
            subscription.info = "Transazione completata."

            customer = Customer.find_by_user_id(subscription.user_id)

            subscription.create_invoice_for(customer)

            subscription.gen_key_for(customer)

            subscription.state = Subscription::STATUS::ACTIVE

            completed = true
          else
            subscription.info = "Pagamento in attesa di verifica."
            completed = false
          end

          # if payment_status == Paypal::PAYMENT::STATUS::REFUNDED
          #   subscription.info = "Rimborso pagamento."
          #   return false
          # end
          #
          # # if mc_gross != subscription.plan.grand_total_string
          # #   subscription.info = "Importo del pagamento non corrisponde al piano scelto."
          # #   return false
          # # end
          #
          # # TODO
          # # - verifica su txn_id

        ensure

          subscription.save

          PaymentNotification.create!(
            :subscription => subscription,
            :detail => self.inspect
          )
        end

        return completed
      end
    end
  end


  def method_missing(method, *args, &block)
    if @payment.respond_to? method
      @payment.send(method, *args, &block)
    else
      super
    end
  end

  def initialize(subscription={})
    case subscription[:action]
    when :request
      @payment = PayPal::SDK::REST::Payment.new({
        :intent => "sale",
        :payer => {
          :payment_method => "paypal" },
        :redirect_urls => {
          :return_url => subscription[:confirm_url],
          :cancel_url => subscription[:cancel_url],
        },
        :transactions => [ {
          :amount => {
            :total => subscription[:amount],
            :currency => "EUR" },
          :description => "#{subscription[:service]}: sottoscrizione piano #{subscription[:plan].downcase} € #{subscription[:amount]}" } ] } )
    when :execute
      @payment = PayPal::SDK::REST::Payment.new({
        :payment_id => subscription[:payment_token]
      })
    end
  end

  def self.find_payment(payment_id)
    @payment = PayPal::SDK::REST::Payment.find(payment_id)
  end

  def request()
    @payment.create
  end

  def approval_url
    @payment.links.find{|v| v.method == "REDIRECT" }.href
  end

  def execute!(payer_id)
    @payment.execute( :payer_id => payer_id )
  end

end
