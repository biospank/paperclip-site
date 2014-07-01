class InvoiceSerial < ActiveRecord::Base

  scope :current, lambda { |date|
    where(:year => date.year)
  }

  def self.next_sequence!()
    # TODO
    # mutex
    pgr = current(Date.today).first

    if pgr.nil?
      pgr = self.create!(
        :serial => 1,
        :year => Date.today.year
      )
    else
      update_attribute(:serial, (pgr.progressivo + 1))
    end

    pgr.serial
  end

end
