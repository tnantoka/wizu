class AddAttachmentDataToAttachments < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.attachment :data
    end
  end

  def self.down
    remove_attachment :attachments, :data
  end
end
