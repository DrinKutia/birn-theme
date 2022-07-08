require 'spec_helper'

RSpec.describe "request_mailer/new_response_reminder_alert" do
  let(:request) { FactoryBot.create(:info_request, :title => "Apostrophe's") }

  before do
    allow(AlaveteliConfiguration).to receive(:site_name).
      and_return("l'Information")
  end

  it "does not add HTMLEntities to the request title" do
    assign(:info_request, request)
    render
    expect(response).to match("Your request was called Apostrophe's")
  end

  it "does not add HTMLEntities to the site name" do
    assign(:info_request, request)
    render
    expect(response).to match("the l'Information team")
  end
end
