# == Schema Information
# Schema version: 20210114161442
#
# Table name: mail_server_log_dones
#
#  id         :integer          not null, primary key
#  filename   :text             not null
#  last_stat  :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Stores that a particular mail server log file has been loaded in, see mail_server_log.rb
#
# Copyright (c) 2009 UK Citizens Online Democracy. All rights reserved.
# Email: hello@mysociety.org; WWW: http://www.mysociety.org/

class MailServerLogDone < ApplicationRecord
  has_many :mail_server_logs,
           :inverse_of => :mail_server_log_done
end
