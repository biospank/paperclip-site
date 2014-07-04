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
    self.key = [(customer.id * 1000), (self.id * 1000), self.expiry_date.to_time.to_i].map do |chunk|
      chunk.to_s.unpack('H*')
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
        description: "Sottoscrizione piano #{self.plan.name.dwoncase}",
        amount: self.plan.price,
        vat: Vat.current
      )
    ]

    invoice.save!

    self.invoice = invoice
  end
end
