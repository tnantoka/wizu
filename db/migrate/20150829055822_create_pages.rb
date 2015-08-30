class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :slug, null: false
      t.string :ancestry
      t.boolean :wiki, null: false, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :pages, :ancestry
    add_index :pages, :slug, unique: true
  end
end
