require 'spec_helper'

RSpec.describe "notification_mailer/response_notification.text.erb" do
  let(:notification) { FactoryBot.create(:notification) }
  let(:info_request_event) { notification.info_request_event }
  let(:incoming_message) { info_request_event.incoming_message }
  let(:info_request) { info_request_event.info_request }

  before do
    allow(AlaveteliConfiguration).to receive(:site_name).
      and_return("l'Information")
  end

  it "does not add HTMLEntities to the FOI law title" do
    allow(info_request).to receive(:legislation).and_return(
      FactoryBot.build(:legislation, full: "Test's Law")
    )
    assign(:info_request, info_request)
    assign(:incoming_message, incoming_message)
    render
    expect(response).to match("the Test's Law request")
  end

  it "does not add HTMLEntities to the site name" do
    assign(:info_request, info_request)
    assign(:incoming_message, incoming_message)
    render
    expect(response).to match("the l'Information team")
  end
end
