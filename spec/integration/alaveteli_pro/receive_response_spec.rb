require 'spec_helper'
require 'integration/alaveteli_dsl'

RSpec.describe "receiving responses to requests in alaveteli_pro" do
  context "when an embargoed request gets a new response" do
    let!(:pro_user) { FactoryBot.create(:pro_user) }
    let!(:pro_user_session) { login(pro_user) }
    let!(:info_request) do
      FactoryBot.create(:embargo_expiring_request,
                        :user => pro_user)
    end

    it "appears in the request list as having received a response" do
      receive_incoming_mail('incoming-request-plain.email',
                            info_request.incoming_email,
                            "Frob <frob@bonce.com>")

      using_pro_session(pro_user_session) do
        visit("#{alaveteli_pro_info_requests_path}" \
              "?alaveteli_pro_request_filter[filter]=response_received")
        expect(page).to have_css("#info-request-#{info_request.id}")
      end
    end

  end

end
