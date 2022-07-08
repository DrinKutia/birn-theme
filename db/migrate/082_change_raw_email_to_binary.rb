class ChangeRawEmailToBinary < ActiveRecord::Migration[4.2] # 2.1
  def self.up
    change_column :raw_emails, :data, :text, :null => true # allow null
    rename_column :raw_emails, :data, :data_text
    add_column :raw_emails, :data_binary, :binary
  end

  def self.down
    raise "safer not to have reverse migration scripts, and we never use them"
  end
end
