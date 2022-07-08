class AddIncomingMessageIndexToOutgoingMessages < ActiveRecord::Migration[4.2] # 2.3
  def self.up
    add_index :outgoing_messages, :incoming_message_followup_id
  end

  def self.down
    remove_index :outgoing_messages, :incoming_message_followup_id
  end
end
