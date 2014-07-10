class Subscription < ActiveRecord::Base

  belongs_to :plan
  has_one :invoice

  validates_presence_of :plan_id
  validates_presence_of :email

  serialize :error

  module STATUS
    ACTIVE = 'active'
  end

  scope :active, lambda {
    where(arel_table[:state].eq(STATUS::ACTIVE).and(
      arel_table[:expiry_date].gt(Date.today))).order(expiry_date: :desc)
  }

  def gen_key_for(customer)
    self.key = [[(customer.id + 1000).to_s], [(self.id + 1000).to_s], [self.expiry_date.to_time.to_i.to_s]].map do |chunk|
      chunk.pack('m')
    end.join('-')
  end

  def create_invoice_for(customer)
    invoice = Invoice.new(
      customer: customer,
      subscription: self,
      number: InvoiceSerial.next_sequence!,
      date: Date.today
    )

    invoice.invoice_lines = [
      InvoiceLine.new(
        description: "#{self.plan.service.name}: sottoscrizione piano #{self.plan.name.downcase}",
        amount: self.plan.discounted_price,
        vat: Vat.current
      )
    ]

    invoice.save!

    self.invoice = invoice
  end
end
