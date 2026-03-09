class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :description
      t.decimal :total_amount
      t.date :date
      t.text :notes
      t.integer :payer_id
      t.integer :household_id
      t.integer :category_id

      t.timestamps
    end
  end
end
