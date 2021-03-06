class RemoveComplaintEmail < ActiveRecord::Migration[4.2] # 2.0
  def self.up
    remove_column :public_body_versions, :complaint_email
    remove_column :public_bodies, :complaint_email
  end

  def self.down
    add_column :public_bodies, :complaint_email, :text
    add_column :public_body_versions, :complaint_email, :text
  end
end
