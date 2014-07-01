Plan.create!(:name => "Trimestrale", :months => 3, :price => 27, :discount => nil)
Plan.create!(:name => "Semestrale", :months => 6, :price => 54, :discount => 5)
Plan.create!(:name => "Annuale", :months => 12, :price => 108, :discount => 10)
Vat.create!(:description => 'Aliquota 22%', :percentage => 22.0, :predefined => true, :active => true)
