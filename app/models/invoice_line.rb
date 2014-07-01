class InvoiceLine < ActiveRecord::Base
  belogns_to :invoice
  belongs_to :vat
end
