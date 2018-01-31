class AddAuseridToOperation < ActiveRecord::Migration[5.0]
  def change
    add_column :operations, :auser_id, :string
  end
end
