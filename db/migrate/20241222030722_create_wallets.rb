class CreateWallets < ActiveRecord::Migration[8.0]
  def change
    create_table :wallets do |t|
      t.integer :user_id, null: false
      t.integer :balance, null: false, default: 0

      t.timestamps
    end
    add_index :wallets, :user_id, unique: true
  end
end
