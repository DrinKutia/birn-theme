class StopNewResponses < ActiveRecord::Migration[4.2] # 2.0
  def self.up
    add_column :info_requests, :stop_new_responses, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :info_requests, :stop_new_responses
  end
end
