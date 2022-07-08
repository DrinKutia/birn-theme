# == Schema Information
# Schema version: 20210114161442
#
# Table name: censor_rules
#
#  id                :integer          not null, primary key
#  info_request_id   :integer
#  user_id           :integer
#  public_body_id    :integer
#  text              :text             not null
#  replacement       :text             not null
#  last_edit_editor  :string           not null
#  last_edit_comment :text             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  regexp            :boolean
#

# models/censor_rule.rb:
# Stores alterations to remove specific data from requests.
#
# Copyright (c) 2008 UK Citizens Online Democracy. All rights reserved.
# Email: hello@mysociety.org; WWW: http://www.mysociety.org/

class CensorRule < ApplicationRecord
  include AdminColumn
  belongs_to :info_request,
             :inverse_of => :censor_rules
  belongs_to :user,
             :inverse_of => :censor_rules
  belongs_to :public_body,
             :inverse_of => :censor_rules

  validate :require_valid_regexp, :if => proc { |rule| rule.regexp? == true }

  validates_presence_of :text,
                        :replacement,
                        :last_edit_comment,
                        :last_edit_editor

  scope :global, -> {
    where(info_request_id: nil,
          user_id: nil,
          public_body_id: nil)
  }

  def apply_to_text(text_to_censor)
    return nil if text_to_censor.nil?
    text_to_censor.gsub(to_replace('UTF-8'), replacement)
  end

  def apply_to_binary(binary_to_censor)
    return nil if binary_to_censor.nil?

    binary_to_censor.gsub(to_replace(binary_to_censor.encoding)) do |match|
      match.gsub(single_char_regexp) { |m| 'x' * m.bytesize }
    end
  end

  def is_global?
    info_request_id.nil? && user_id.nil? && public_body_id.nil?
  end

  def expire_requests
    if info_request
      info_request.expire
    elsif user
      user.expire_requests
    elsif public_body
      public_body.expire_requests
    else # global rule
      InfoRequest.find_in_batches do |group|
        group.each { |request| request.expire }
      end
    end
  end

  def censorable_requests
    if info_request
      # Prefer a chainable query instead of wrapping in Array for similar API
      # between CensorRule types
      InfoRequest.where(id: info_request_id)
    elsif user
      user.info_requests
    elsif public_body
      public_body.info_requests
    else
      InfoRequest.unscoped
    end
  end

  private

  def single_char_regexp
    Regexp.new('.'.force_encoding('ASCII-8BIT'))
  end

  def require_valid_regexp
    begin
      make_regexp('UTF-8')
    rescue RegexpError => e
      errors.add(:text, e.message)
    end
  end

  def to_replace(encoding)
    regexp? ? make_regexp(encoding) : encoded_text(encoding)
  end

  def encoded_text(encoding)
    text.dup.force_encoding(encoding)
  end

  def make_regexp(encoding)
    ::Warning.with_raised_warnings do
      Regexp.new(encoded_text(encoding), Regexp::MULTILINE)
    end
  rescue RaisedWarning => e
    raise RegexpError, e.message.split('warning: ').last.chomp
  end
end
