class Service < ActiveRecord::Base

  has_and_belongs_to_many :customers

  module PAPERCLIP
    SINGLE = 1
    NET = 2
    CLOUD = 3
  end

end
