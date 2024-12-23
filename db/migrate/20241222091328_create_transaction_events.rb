class CreateTransactionEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :transaction_events do |t|
      t.integer :wallet_id, null: false
      t.integer :source_wallet_id
      t.integer :amount, null: false
      t.integer :balance, null: false
      t.integer :transaction_type, null: false

      t.datetime :created_at, null: false
    end

    add_index :transaction_events, [ :wallet_id, :created_at ]
  end
end
