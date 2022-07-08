require 'no_constraint_disabling'
require 'rspec/rails'
require Rails.root.join("spec", "support", "load_file_fixtures")
require Rails.root.join("spec", "support", "email_helpers")

RSpec.configure do |config|
  config.fixture_path = Rails.root.join("spec","fixtures")
end

# HACK: Normally to load fixtures you'd run  (with
#  if using specs instead of tests) but unless
# we can find a good fix for not being able to disable Postgres constraints
# (especially for foreign keys) without being the superuser, we have to load
# our fixture files in the right order
#
# Note - the original hack was to avoid unintentionally loading csv data
# but that was fixed in Rails 3.2

fixtures_dir = Rails.root.join("spec","fixtures").to_s

# specify the order in which to unload and load the data
# (create_fixtures reverses the order during deletion then loads forwards)
fixture_files = ["public_bodies",
                 "public_body_versions",
                 "users",
                 "info_requests",
                 "comments",
                 "raw_emails",
                 "incoming_messages",
                 "outgoing_messages",
                 "info_request_events",
                 "track_things"]

# append everything else that isn't order critical
Dir["#{fixtures_dir}/**/*.yml"].map{ |f| f[(fixtures_dir.size + 1)..-5] }.each do |fixture|
  next if fixture =~ /yaml_compatibility|refusal_advice/
  fixture_files << fixture unless fixture_files.include?(fixture)
end

# run everything as a single transaction - all the deletes then all the inserts
ActiveRecord::FixtureSet.create_fixtures(fixtures_dir, fixture_files)

load_raw_emails_data
