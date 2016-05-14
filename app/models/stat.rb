class Stat < ActiveRecord::Base
  has_many :values, primary_key: :stat_hash, foreign_key: :stat_hash
end
