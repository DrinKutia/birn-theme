class AddReasonsToPostRedirects < ActiveRecord::Migration[4.2] # 1.2
  def self.up
    add_column :post_redirects, :reason_params_yaml, :text
    add_column :post_redirects, :user_id, :integer
  end

  def self.down
    remove_column :post_redirects, :reason_params_yaml
    remove_column :post_redirects, :user_id
  end
end
