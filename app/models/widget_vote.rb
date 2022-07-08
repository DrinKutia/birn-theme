# == Schema Information
# Schema version: 20210114161442
#
# Table name: widget_votes
#
#  id              :integer          not null, primary key
#  cookie          :string
#  info_request_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class WidgetVote < ApplicationRecord
  belongs_to :info_request,
             :inverse_of => :widget_votes

  validates :info_request, :presence => true
  validates :cookie, length: { is: 20 }
  validates :cookie, uniqueness: { scope: :info_request_id }
end
