class IndicesForAnnotations < ActiveRecord::Migration[4.2] # 2.0
  def self.up
    add_index :info_request_events, :created_at
    add_index :info_request_events, :info_request_id
  end

  def self.down
    remove_index :info_request_events, :created_at
    remove_index :info_request_events, :info_request_id
  end
end
