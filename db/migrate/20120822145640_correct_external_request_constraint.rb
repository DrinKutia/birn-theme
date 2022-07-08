class CorrectExternalRequestConstraint < ActiveRecord::Migration[4.2] # 2.3
  def self.up
    if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
      execute "ALTER TABLE info_requests DROP CONSTRAINT info_requests_external_ck"
      execute "ALTER TABLE info_requests ADD CONSTRAINT info_requests_external_ck CHECK ( (user_id is null) = (external_url is not null) and (external_url is not null or external_user_name is null) )"
    end
  end

  def self.down
    if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
      execute "ALTER TABLE info_requests DROP CONSTRAINT info_requests_external_ck"
      execute "ALTER TABLE info_requests ADD CONSTRAINT info_requests_external_ck CHECK ( (user_id is null) = (external_url is not null) and (external_user_name is not null or external_url is null) )"
    end
  end
end
