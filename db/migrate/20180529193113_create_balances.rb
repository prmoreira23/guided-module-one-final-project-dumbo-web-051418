class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.integer :account_id
      t.integer :coin_id
      t.float :amount
    end
  end
end
