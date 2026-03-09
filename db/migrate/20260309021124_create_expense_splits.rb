class CreateExpenseSplits < ActiveRecord::Migration[8.0]
  def change
    create_table :expense_splits do |t|
      t.integer :expense_id
      t.integer :user_id
      t.decimal :amount_owed

      t.timestamps
    end
  end
end
