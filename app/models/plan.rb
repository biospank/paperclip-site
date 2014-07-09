class Plan < ActiveRecord::Base
  has_many :subscriptions
  belongs_to :service

  def expiry_date
    Date.today.months_since(self.months)
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
end
