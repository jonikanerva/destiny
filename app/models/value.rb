class Value < ActiveRecord::Base
  belongs_to :item
  belongs_to :stat, primary_key: :stat_hash, foreign_key: :stat_hash
end
