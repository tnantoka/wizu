class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :slug, null: false
      t.references :page, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
