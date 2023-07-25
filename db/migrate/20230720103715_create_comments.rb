class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :order, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :tour, null: false, foreign_key: true
      t.text :review
      t.integer :rate

      t.timestamps
    end
  end
end
