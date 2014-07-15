require 'rails_helper'

describe Subscription do
  describe "valid:" do
    before(:each) do
      @subscription = build(:subscription)
    end

    it "is valid with plan and email" do
      expect(@subscription).to be_valid
    end
  end

  describe "invalid:" do
    it "is invalid without a plan"
    it "is invalid without an email"
  end

  describe "active:" do

  end

end
