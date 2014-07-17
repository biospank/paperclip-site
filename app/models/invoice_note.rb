class InvoiceNote < ActiveRecord::Base
  scope :active, -> {
    where(:active => true)
  }
end
