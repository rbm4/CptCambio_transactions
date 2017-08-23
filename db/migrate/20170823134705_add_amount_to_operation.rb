class AddAmountToOperation < ActiveRecord::Migration
  def change
    add_column :operations, :amount, :string
  end
end
