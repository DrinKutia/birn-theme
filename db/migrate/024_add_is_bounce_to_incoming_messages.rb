class AddIsBounceToIncomingMessages < ActiveRecord::Migration[4.2] # 2.0
  def self.up
    add_column :incoming_messages, :is_bounce, :boolean, :default => false
    IncomingMessage.update_all "is_bounce = 'f'"
  end

  def self.down
    remove_column :incoming_messages, :is_bounce
  end
end
