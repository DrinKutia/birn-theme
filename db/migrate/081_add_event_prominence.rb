class AddEventProminence < ActiveRecord::Migration[4.2] # 2.1
  def self.up
    add_column :info_request_events, :prominence, :string, :null => false, :default => 'normal'
  end

  def self.down
    raise "safer not to have reverse migration scripts, and we never use them"
  end
end
