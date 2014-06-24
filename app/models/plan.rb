class Plan < ActiveRecord::Base
  has_many :subscriptions

  def expiry_date
    Date.today.months_since(self.months)
  end

  def discounted_price
    discount ? (price - ((price * discount) / 100)).round(2) : price
  end

  def discounted_price_decimal
    '%.2f' % discounted_price
  end
end
