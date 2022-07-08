class CreateUsers < ActiveRecord::Migration[4.2] # 1.2
  def self.up
    create_table :users do |t|
      t.column :email, :string
      t.column :name, :string

      t.column :hashed_password, :string
      t.column :salt, :string
    end
  end

  def self.down
    drop_table :users
  end
end
