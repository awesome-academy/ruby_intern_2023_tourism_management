class CreateTours < ActiveRecord::Migration[6.1]
  def change
    create_table :tours do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.integer :cost
      t.text :visit_location
      t.text :start_location

      t.timestamps
    end
  end
end
