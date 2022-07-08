class AddCommentsToUserTrack < ActiveRecord::Migration[4.2] # 2.1
  def self.up
    TrackThing.update_all "track_query = replace(track_query, 'variety:sent ', '') where track_type in ('public_body_updates', 'user_updates')"
    TrackThing.where(:track_type => 'user_updates').each do |track_thing|
      track_thing.track_query = track_thing.track_query.gsub(/^requested_by:([^\s]+)$/, "requested_by:\\1 OR commented_by:\\1")
      track_thing.save!
    end
  end

  def self.down
    # TODO: forget it
  end
end
