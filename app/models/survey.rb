##
# Class responsible for generating URLs to user survey. Base URL configured at
# the SURVEY_URL option. We append an `authority_id` query parameter if the user
# in question isn't obviously identifiable - EG if more then 10 other requesters
# have requests to the same PublicBody
#
class Survey
  def self.enabled?
    url.present?
  end

  def self.url
    AlaveteliConfiguration.survey_url
  end

  def self.date_range
    period = 1.month
    period.ago.at_beginning_of_day..period.ago.at_end_of_day
  end

  def initialize(public_body)
    @public_body = public_body
  end

  def url
    return Survey.url if user_too_identifiable?

    uri = URI(Survey.url)

    new_query = Hash[URI.decode_www_form(uri.query.to_s)].merge(
      authority_id: public_body.to_param
    )
    uri.query = URI.encode_www_form(new_query)

    uri.to_s
  end

  protected

  attr_reader :public_body

  private

  def user_too_identifiable?
    User.distinct.joins(:info_requests).
      where(info_requests: { public_body: public_body }).
      count < 10
  end
end
