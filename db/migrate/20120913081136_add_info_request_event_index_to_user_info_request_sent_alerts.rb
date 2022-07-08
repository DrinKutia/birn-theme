class AddInfoRequestEventIndexToUserInfoRequestSentAlerts < ActiveRecord::Migration[4.2] # 2.3
  def self.up
    add_index :user_info_request_sent_alerts, :info_request_event_id
  end

  def self.down
    remove_index :user_info_request_sent_alerts, :info_request_event_id
  end
end
