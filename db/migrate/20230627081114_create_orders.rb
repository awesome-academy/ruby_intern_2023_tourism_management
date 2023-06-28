class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :tour, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :note
      t.integer :status
      t.integer :amount_member
      t.integer :tour_guide
      t.integer :total_cost
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_address

      t.timestamps
    end
  end
end
