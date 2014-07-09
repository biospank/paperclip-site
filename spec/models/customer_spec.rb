require 'rails_helper'

describe Customer do
  describe "valid:" do
    before :each do
      @customer = build(:customer)
    end

    it "is valid with name, tax_code, address, cap, city" do
      expect(@customer).to be_valid
    end

    it "is valid with alphanumeric, 16 character long tax_code" do
      @customer.tax_code = "PTRFBA71E09H501Z"
      expect(@customer).to be_valid
    end
  end

  describe "invalid:" do
    before :each do
      @customer = build(:customer)
      #FactoryGirl.lint
    end

    it "is invalid without name" do
      @customer.name = nil
      expect(@customer).not_to be_valid
      expect(@customer.errors).to include(:name)
    end

    it "is invalid without tax_code" do
      @customer.tax_code = nil
      expect(@customer).not_to be_valid
      expect(@customer.errors).to include(:tax_code)
    end

    it "is invalid without address" do
      @customer.address = nil
      expect(@customer).not_to be_valid
      expect(@customer.errors).to include(:address)
    end

    it "is invalid without cap" do
      @customer.cap = nil
      expect(@customer).not_to be_valid
      expect(@customer.errors).to include(:cap)
    end

    it "is invalid without city" do
      @customer.city = ""
      expect(@customer).not_to be_valid
      expect(@customer.errors).to include(:city)
    end

    context "numeric tax_code" do
      it "is invalid with length != 11" do
        @customer.tax_code = "122345"
        expect(@customer).not_to be_valid
        expect(@customer.errors).to include(:tax_code)
      end

      it "is invalid with duplicate tax_code" do
        create(:customer, tax_code: '12345678901')
        @customer.tax_code = "12345678901"
        expect(@customer).not_to be_valid
        expect(@customer.errors).to include(:tax_code)
      end
    end

    context "alphanumeric tax_code" do
      it "is invalid with length != 16" do
        @customer.tax_code = "PTRFBA71E09501Z"
        expect(@customer).not_to be_valid
        expect(@customer.errors).to include(:tax_code)
      end

      it "is invalid with duplicate tax_code" do
        create(:customer, tax_code: 'PTRFBA71E09H501Z')
        @customer.tax_code = "PTRFBA71E09H501Z"
        expect(@customer).not_to be_valid
        expect(@customer.errors).to include(:tax_code)
      end
    end


  end

end
