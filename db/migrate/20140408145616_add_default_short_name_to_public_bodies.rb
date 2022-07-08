class AddDefaultShortNameToPublicBodies < ActiveRecord::Migration[4.2] # 3.2

  def up
    change_column_default(:public_bodies, :short_name, '')
  end

  def down
    change_column_default(:public_bodies, :short_name, nil)
  end

end
