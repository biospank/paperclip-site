class Plan < ActiveRecord::Base
  has_many :subscriptions
  
  def expiry_date
    Date.today.months_since(self.months)
  end
end