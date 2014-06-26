class PaymentNotification < ActiveRecord::Base

  belongs_to :subscription

  serialize :detail

end
