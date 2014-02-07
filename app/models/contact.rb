class Contact < ActiveRecord::Base
	# has_no_table

 #  column :name, :string 
 #  column :email, :string 
 #  column :phone, :string 
 #  column :message, :text

  validates_presence_of :name 
  validates_presence_of :email 
  validates_format_of :email,
    :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i 
  validates_presence_of :message 
  validates_length_of :message, :maximum => 500

end
