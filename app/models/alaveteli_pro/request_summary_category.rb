# == Schema Information
# Schema version: 20210114161442
#
# Table name: request_summary_categories
#
#  id         :integer          not null, primary key
#  slug       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AlaveteliPro::RequestSummaryCategory < ApplicationRecord
  has_and_belongs_to_many :request_summaries,
                          :class_name => "AlaveteliPro::RequestSummary",
                          :inverse_of => :request_summary_categories

  def self.draft
    return find_by(slug: "draft")
  end

  def self.complete
    return find_by(slug: 'complete')
  end

  def self.clarification_needed
    return find_by(slug: 'clarification_needed')
  end

  def self.awaiting_response
    return find_by(slug: 'awaiting_response')
  end

  def self.response_received
    return find_by(slug: 'response_received')
  end

  def self.overdue
    return find_by(slug: 'overdue')
  end

  def self.very_overdue
    return find_by(slug: 'very_overdue')
  end

  def self.other
    return find_by(slug: 'other')
  end

  def self.embargo_expiring
    return find_by(slug: 'embargo_expiring')
  end
end
