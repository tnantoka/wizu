class RemoveWikiFromPages < ActiveRecord::Migration
  def change
    remove_column :pages, :wiki
  end
end
