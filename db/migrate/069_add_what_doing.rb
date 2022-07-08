class AddWhatDoing < ActiveRecord::Migration[4.2] # 2.1
  def self.up
    add_column :outgoing_messages, :what_doing, :string
    add_index :outgoing_messages, :what_doing
    OutgoingMessage.update_all "what_doing = 'normal_sort'"
    change_column :outgoing_messages, :what_doing, :string, :null => false
  end

  def self.down
    remove_column :outgoing_messages, :what_doing
  end
end
