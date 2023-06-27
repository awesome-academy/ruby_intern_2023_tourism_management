class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.integer :duration
      
      t.index :name, :unique => true
      t.timestamps
    end
  end
end
