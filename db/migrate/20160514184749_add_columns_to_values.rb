class AddColumnsToValues < ActiveRecord::Migration
  def change
    add_column :values, :stat_name, :string
    add_column :values, :stat_description, :text
  end
end
