class Vat < ActiveRecord::Base

  scope :current, lambda {
    where(predefined: true, active: true).first
  }
end
