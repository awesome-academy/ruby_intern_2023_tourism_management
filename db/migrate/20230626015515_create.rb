class Create < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.string :remember_digest
      t.integer :role, default: 0
      t.index ["email"], name: "index_users_on_email", unique: true

      t.timestamps
    end
  end
end
