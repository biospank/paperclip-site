module SubscriptionsHelper
  STATUS_CLASS = {
    :approved => 'active',
    :pending => 'warning',
    :active => 'success',
    :expired => 'danger',
    :refunded => 'warning'
  }

end
