class Plan < ActiveRecord::Base
  has_many :subscriptions
  belongs_to :service

  def expiry_date
    (Date.today.months_since(self.months) + 7)
  end

  def discount_amount
    discount ? ((price * discount) / 100) : 0
  end

  def discounted_price
    discount ? (price - discount_amount).round(2) : price
  end

  def discounted_price_decimal
    '%.2f' % discounted_price
  end

  def vat_amount
    ((discounted_price * Vat.current.percentage) / 100)
  end

  def grand_total
    discounted_price + vat_amount
  end

  def grand_total_string
    '%.2f' % grand_total
  end
end
