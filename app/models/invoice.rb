class Invoice < ActiveRecord::Base
  include WkHelper

  belongs_to :customer
  belongs_to :subscription
  has_many :invoice_lines, class_name: 'InvoiceLine', dependent: :delete_all

  accepts_nested_attributes_for :invoice_lines

  validates :customer, :subscription, :number, :date, presence: true
  validates :number, uniqueness: true

  validate :past_date

  def pdf_exist?
    pdf_path = File.join(WkHelper::PUBLIC_PATH, WkHelper::PDF_PATH, (pdf_name + pdf_suffix))

    if File.exist?(pdf_path)
      return pdf_path
    else
      return nil
    end
  end

  def generate_pdf(ctx)
    generate(pdf_name,
      :header => false,
      :margin_top => 20,
      :margin_bottom => 85, # 65
      :ctx => ctx
    )
  end

  def render_body(opts={})
    body.write(
      Tilt.new(InvoiceHelper::InvoiceBodyTemplatePath).render(opts[:ctx], invoice: self)
    )
  end

  def render_footer(opts={})
    footer.write(
      Tilt.new(InvoiceHelper::InvoiceFooterTemplatePath).render(opts[:ctx], invoice: self)
    )
  end

  # calcolo dell'imponibile partendo dal totale
  # def taxable_amount()
  #   (amount() - vat_amount())
  # end
  #
  # # scorporo iva partendo da un totale
  # def vat_spin_off()
  #   vat_percentage = Vat.current.percentage
  #   total = amount()
  #   ((total * vat_percentage) / (vat_percentage + 100))
  # end

  def vat_amount()
    self.invoice_lines.map do |line|
      line.vat_amount
    end.reduce(:+)
  end

  def amount
    @amount ||= self.invoice_lines.sum(:amount)
  end

  def grand_total
    amount + vat_amount
  end

  protected

  def pdf_name
    "fattura_#{self.number}_#{self.date.year}"
  end

  def pdf_suffix
    ".pdf"
  end

  def past_date
    errors.add(:date, message: "La data non può essere passata") if !self.date.nil? && self.date.past?
  end
end
