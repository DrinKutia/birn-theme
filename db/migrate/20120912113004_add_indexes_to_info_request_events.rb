class AddIndexesToInfoRequestEvents < ActiveRecord::Migration[4.2] # 2.3
  def self.up
    add_index :info_request_events, :incoming_message_id
    add_index :info_request_events, :outgoing_message_id
    add_index :info_request_events, :comment_id
  end

  def self.down
    remove_index :info_request_events, :incoming_message_id
    remove_index :info_request_events, :outgoing_message_id
    remove_index :info_request_events, :comment_id
  end
end
