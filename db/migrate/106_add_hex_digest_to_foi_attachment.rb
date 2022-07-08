class AddHexDigestToFoiAttachment < ActiveRecord::Migration[4.2] # 2.3
  def self.up
    add_column :foi_attachments, :hexdigest, :string, :limit => 32
  end

  def self.down
    remove_column :foi_attachments, :hexdigest
  end
end
