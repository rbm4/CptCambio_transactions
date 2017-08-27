class RemoveTypeAddTipo < ActiveRecord::Migration
  def change
    remove_column :operations, :type
    add_column :operations, :tipo, :string
  end
end
