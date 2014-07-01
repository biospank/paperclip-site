class Invoice < ActiveRecord::Base
  include WkHelper

  belongs_to :customer
  has_many :invoice_lines, class_name: 'InvoiceLine', dependent: 'delete_all'

  accept_nested_attributes_for :invoice_lines

  def generate_invoice
    generate("fattura_#{self.number}_#{self.date.year}",
      :margin_top => 90,
      :margin_bottom => 65,
    )
  end

  def render_header(opts={})
    header.write(
      Tilt.new[InvoiceHelper::InvoiceHeaderTemplatePath].render(scope)
    )
  end

  def render_body(opts={})
    body.write(
      Tilt.new[InvoiceHelper::InvoiceBodyTemplatePath].render(scope)
    )
  end

  def render_footer(opts={})
    footer.write(
      Tilt.new[InvoiceHelper::InvoiceFooterTemplatePath].render(scope)
    )
  end

end
