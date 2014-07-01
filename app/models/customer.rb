class Customer < ActiveRecord::Base

  belongs_to :user

  validates :name, :tax_code, :address, presence: {
allow_blank: false,
    message: "Tutti i dati sono obbligatori"
  }
  validates :tax_code, length: {
    is: 11,
    if: lambda { |customer|
      return true unless customer.tax_code
      customer.tax_code.match(/^[0-9]+$/)
    },
    allow_blank: false,
    message: "La Patita Iva deve essere di 11 caratteri"
  }
  validates :tax_code, length: {
    is: 16,
    if: lambda { |customer|
      return true unless customer.tax_code
      customer.tax_code =~ /(\D)+/
    },
    allow_blank: false,
    message: "Il codice fiscale deve essere di 16 caratteri"
  }
  validates :tax_code, uniqueness: {
    allow_blank: false,
    message: "Il Codice Fiscale o la partita iva inserita è già utilizzata"
  }

  def error_message
    errors.messages.first.last.first
  end
end
