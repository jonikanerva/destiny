class Item < ActiveRecord::Base
  has_many :values
  has_many :stats, through: :values
end
