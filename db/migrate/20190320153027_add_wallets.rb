class AddWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.text :address
      
      t.references :user, null: false
    end 

  end
end
