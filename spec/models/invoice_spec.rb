describe Invoice do

  describe "valid" do
    before :each do
      @invoice = FactoryGirl.build(:invoice)
    end

    it "expose method #generate" do
      expect(@invoice).to respond_to(:generate)
    end

    it "is valid with a customer, subscription, number and date" do
      expect(@invoice).to be_valid
    end
  end

  it "is not valid without customer" do
    @invoice = FactoryGirl.build(:invoice, customer: nil)
    expect(@invoice).not_to be_valid
    expect(@invoice.errors).to include(:customer)
  end

  it "is not valid without subscription" do
    @invoice = FactoryGirl.build(:invoice, subscription: nil)
    expect(@invoice).not_to be_valid
    expect(@invoice.errors).to include(:subscription)
  end

  it "is not valid without number" do
    @invoice = FactoryGirl.build(:invoice, number: nil)
    expect(@invoice).not_to be_valid
    expect(@invoice.errors).to include(:number)
  end

  it "is not valid with duplicate number" do
    FactoryGirl.create(:invoice)
    @invoice = FactoryGirl.build(:invoice)
    expect(@invoice).not_to be_valid
    expect(@invoice.errors).to include(:number)
  end

  it "is not valid without date" do
    @invoice = FactoryGirl.build(:invoice, date: nil)
    expect(@invoice).not_to be_valid
    expect(@invoice.errors).to include(:date)
  end

  it "is not valid with past date" do
    @invoice.date = Date.yesterday
    expect(@invoice).not_to be_valid
    expect(@invoice.errors).to include(:date)
  end

  
end
