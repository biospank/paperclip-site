class SubscriptionPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.where(:state => [Paypal::PAYMENT::STATUS::PENDING, Paypal::PAYMENT::STATUS::APPROVED])
    end
  end

  def recap?
    owner?
  end

  def execute?
    owner?
  end

  def cancel?
    owner?
  end

  private

  def owner?
    record.user_id == user.id
  end
end
