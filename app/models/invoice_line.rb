class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :vat

  # calcolo dell'imponibile partendo dal totale
  def taxable_amount()
    (self.amount - vat_amount())
  end

  # scorporo iva partendo da un totale
  def vat_amount()
    ((self.amount * self.vat.percentage) / (self.vat.percentage + 100))
  end

end
