class Subscription < ActiveRecord::Base

  belongs_to :plan
  #belongs_to :customer
  validates_presence_of :plan_id
  validates_presence_of :email

  serialize :error

  def gen_key_for(user)
    self.key = [user.id, plan.months, (Date.today + 3)].map do |chunk|
      chunk.to_s.unpack('H*')
    end.join('-')
  end
end
