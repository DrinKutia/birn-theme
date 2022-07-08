class AlterProfilePhoto < ActiveRecord::Migration[4.2] # 2.3
  def self.up
    remove_column :users, :profile_photo_id
  end

  def self.down
    raise "No reverse migration"
  end
end
