class SubscriptionPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    # viene chiamato usando il metodo policy_scope
    # applica i criteri di ricerca legati allo stato
    # della sottoscrizione e al suo utente.
    def resolve
      scope.where("lower(state) in (?)", [
        Paypal::PAYMENT::STATUS::PENDING.downcase,
        Paypal::PAYMENT::STATUS::APPROVED.downcase,
        Paypal::PAYMENT::STATUS::COMPLETED.downcase]
      ).where(:user_id => user.id)
    end
  end

  # metodi di autorizzazzione.
  # chiamati usando il metodo authorize sulle rispettive action

  def show?
    owner?
  end

  def thank_you?
    owner?
  end

  def invoice_download?
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
