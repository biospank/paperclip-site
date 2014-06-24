class Paypal
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
          :description => "Paperclip: servizio in abbonamento" } ] } )
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

  def error
    @payment.error
  end

end
