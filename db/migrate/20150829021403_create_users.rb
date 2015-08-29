class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nickname, null: false
      t.text :image, null: false

      t.timestamps null: false
    end
    add_index :users, :nickname, unique: true
  end
end
