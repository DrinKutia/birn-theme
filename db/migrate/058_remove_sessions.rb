class RemoveSessions < ActiveRecord::Migration[4.2] # 2.0
  def self.up
    drop_table :sessions
  end

  def self.down
    create_table :sessions do |t|
      t.column :session_id, :string
      t.column :data, :text
      t.column :updated_at, :datetime
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at
  end
end
