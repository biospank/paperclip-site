require 'rails_helper'

describe Contact do
  before :each do
    @contact = FactoryGirl.build(:contact)
  end

  it "is valid with a name, email and message" do
    @contact.name = 'Fabio'
    @contact.email = 'fabio.petrucci@gmail.com'
    @contact.message = 'Prodotto interessante'

    expect(@contact).to be_valid
  end

  describe "name" do
    context "invalid name" do

      before :each do
        @contact.name = nil
      end

      it "is invalid without a name" do
        expect(@contact).not_to be_valid
        expect(@contact.errors).to include(:name)
      end

    end
  end

  describe "email" do
    before do
      @contact.email = nil
    end

    context "invalid email" do
      it "is invalid without an email" do
        expect(@contact).not_to be_valid
        expect(@contact.errors).to include(:email)
      end

      it "is invalid with malformed email" do
        @contact.email = "fabio.petrucci.com"
        expect(@contact).not_to be_valid
        expect(@contact.errors).to include(:email)
      end

    end
  end

  describe "message" do
    context "invalid message" do

      before do
        @contact.message = nil
      end

      it "is invalid without a message" do
        expect(@contact).not_to be_valid
        expect(@contact.errors).to include(:message)
      end

      it "is invalid if message exceed 500 characters" do
        @contact.message = ('*' * 501)
        expect(@contact).not_to be_valid
        expect(@contact.errors).to include(:message)
      end

    end
  end

end
