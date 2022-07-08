class AddAttachmentText < ActiveRecord::Migration[4.2] # 2.0
  def self.up
    add_column :incoming_messages, :cached_attachment_text, :text
  end

  def self.down
    remove_column :incoming_messages, :cached_attachment_text
  end
end
