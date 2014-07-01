class Subscription < ActiveRecord::Base

  belongs_to :plan
  has_one :invoice

  validates_presence_of :plan_id
  validates_presence_of :email

  serialize :error

  def gen_key_for(customer)
    self.key = [(customer.id * 1000), (plan.months * 1000), (Date.today + 3)].map do |chunk|
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
        description: "Sottoscrizione al piano #{self.plan.name}",
        amount: # scorporo,
        vat: Vat.current
      )
    ]

    invoice.save!

    self.invoice = invoice
  end
end
