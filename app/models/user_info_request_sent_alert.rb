# == Schema Information
# Schema version: 20210114161442
#
# Table name: user_info_request_sent_alerts
#
#  id                    :integer          not null, primary key
#  user_id               :integer          not null
#  info_request_id       :integer          not null
#  alert_type            :string           not null
#  info_request_event_id :integer
#  created_at            :datetime
#  updated_at            :datetime
#

# models/user_info_request_sent_alert.rb:
# Whether an alert has been sent to this user for this info_request, for a
# given type of alert.
#
# Copyright (c) 2008 UK Citizens Online Democracy. All rights reserved.
# Email: hello@mysociety.org; WWW: http://www.mysociety.org/

class UserInfoRequestSentAlert < ApplicationRecord
  ALERT_TYPES = [
    'overdue_1', # tell user that info request has become overdue
    'very_overdue_1', # tell user that info request has become very overdue
    'new_response_reminder_1', # reminder user to classify the recent
    # response
    'new_response_reminder_2', # repeat reminder user to classify the
    # recent response
    'new_response_reminder_3', # repeat reminder user to classify the
    # recent response
    'not_clarified_1', # reminder that user has to explain part of the
    # request
    'comment_1', # tell user that info request has a new comment
    'embargo_expiring_1', # tell user that their embargo is expiring
    'embargo_expired_1', # tell user that their embargo has expired
    'survey_1' # ask the user to complete a survey regarding their recent
    # request
  ]

  belongs_to :user,
             :inverse_of => :user_info_request_sent_alerts
  belongs_to :info_request,
             :inverse_of => :user_info_request_sent_alerts
  belongs_to :info_request_event,
             :inverse_of => :user_info_request_sent_alerts

  validates_inclusion_of :alert_type, :in => ALERT_TYPES

  scope :recent, -> { where(created_at: 1.year.ago.to_date..Float::INFINITY) }
end
