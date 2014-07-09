#User.new(:email => "fabio.petrucci@gmail.com", :encrypted_password => "$2a$10$/kiVWg1o/vcw2spI2EsMPOzCHYF.kVmRJc1m4lIyT2eSFNQ925c8i", :admin => true).save(:validate => false)
Service.create!(:id => 1, :name => 'Paperclip Single')
Service.create!(:id => 2, :name => 'Paperclip Net')
Service.create!(:id => 3, :name => 'Paperclip Cloud')
Plan.create!(:service_id => 1, :name => "Trimestrale", :months => 3, :price => 27, :discount => nil)
Plan.create!(:service_id => 1, :name => "Semestrale", :months => 6, :price => 54, :discount => 5)
Plan.create!(:service_id => 1, :name => "Annuale", :months => 12, :price => 108, :discount => 10)
Plan.create!(:service_id => 2, :name => "Trimestrale", :months => 3, :price => 87, :discount => nil)
Plan.create!(:service_id => 2, :name => "Semestrale", :months => 6, :price => 174, :discount => 5)
Plan.create!(:service_id => 2, :name => "Annuale", :months => 12, :price => 348, :discount => 10)
Plan.create!(:service_id => 3, :name => "Trimestrale", :months => 3, :price => 147, :discount => nil)
Plan.create!(:service_id => 3, :name => "Semestrale", :months => 6, :price => 294, :discount => 5)
Plan.create!(:service_id => 3, :name => "Annuale", :months => 12, :price => 588, :discount => 10)
Vat.create!(:description => 'Aliquota 22%', :percentage => 22.0, :predefined => true, :active => true)
