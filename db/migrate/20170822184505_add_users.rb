class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.integer :id_original
      t.string :email
      t.string :name
 
      t.timestamps
    end
  end
end
