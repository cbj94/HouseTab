class CreateSettlements < ActiveRecord::Migration[8.0]
  def change
    create_table :settlements do |t|
      t.integer :payer_id
      t.integer :payee_id
      t.integer :household_id
      t.decimal :amount
      t.date :date
      t.text :notes

      t.timestamps
    end
  end
end
