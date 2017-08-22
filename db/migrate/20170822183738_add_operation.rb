class AddOperation < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.string :currency
      t.string :type
      t.string :user_id
      t.boolean :debit_credit #false = descontar crédito, true = contabilizar crédito
      
 
      t.timestamps
    end
  end
end
