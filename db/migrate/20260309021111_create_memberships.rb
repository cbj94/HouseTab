class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :household_id
      t.string :role

      t.timestamps
    end
  end
end
