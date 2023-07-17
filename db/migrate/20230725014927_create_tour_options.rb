class CreateTourOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :options do |t|
      t.string :option_name
      t.integer :option_cost

      t.timestamps
      t.index :option_name, :unique => true
    end

    create_table :tour_options do |t|
      t.references :tour, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
