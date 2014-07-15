require 'rails_helper'

describe InvoiceSerial do
  before :each do
    @num = InvoiceSerial.next_sequence!
  end

  context "on new year:" do
    it "has no records" do
      seq = InvoiceSerial.find_by_year(Date.today.next_year())
      expect(seq).to be_blank
    end
  end

  context "on next_sequence! first call" do
    it "create a new record with current year" do
      is = InvoiceSerial.first
      expect(is.year).to be_eql(Date.today.year)
    end
    it "start from 1" do
      is = InvoiceSerial.first
      expect(is.serial).to be_eql(1)
    end
  end

  context "on next_sequence! subsequent call " do
    it "increment serial by 1" do
      num = InvoiceSerial.next_sequence!
      expect(num).to be_eql(2)
    end
    it "has one record per year" do
      InvoiceSerial.create(serial: 1, year: 2015)
      InvoiceSerial.next_sequence!
      expect(InvoiceSerial.where(year: 2014).count).to be_eql(1)
      expect(InvoiceSerial.where(year: 2015).count).to be_eql(1)
    end
  end
end
