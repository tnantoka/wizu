class AddSecretToPages < ActiveRecord::Migration
  def change
    add_column :pages, :secret, :boolean, null: false, default: true
  end
end
