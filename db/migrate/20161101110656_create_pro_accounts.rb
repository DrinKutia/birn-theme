class CreateProAccounts < ActiveRecord::Migration[4.2] # 3.2
  def change
    create_table :pro_accounts do |t|
      t.column :user_id, :integer, null: false
      t.column :default_embargo_duration, :string

      t.timestamps null: false
    end
  end
end
