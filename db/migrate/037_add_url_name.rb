class AddUrlName < ActiveRecord::Migration[4.2] # 2.0
  def self.up
    add_column :public_bodies, :url_name, :text
    add_column :public_body_versions, :url_name, :text

    PublicBody.find_each do |public_body|
      public_body.update_url_name
      public_body.save!
    end
    # MySQL cannot index text blobs like this
    if ActiveRecord::Base.connection.adapter_name != "MySQL"
      add_index :public_bodies, :url_name, :unique => true
    end
    change_column :public_bodies, :url_name, :text, :null => false
  end

  def self.down
    remove_column :public_bodies, :url_name
    remove_column :public_body_versions, :url_name
  end
end
