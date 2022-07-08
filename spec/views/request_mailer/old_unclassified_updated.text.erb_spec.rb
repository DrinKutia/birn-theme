require 'spec_helper'

RSpec.describe "request_mailer/old_unclassified_updated" do
  let(:body) { FactoryBot.create(:public_body, :name => "Apostrophe's") }
  let(:request) do
    FactoryBot.create(:info_request,
                      :public_body => body,
                      :title => "Request apostrophe's data")
  end

  before do
    allow(AlaveteliConfiguration).to receive(:site_name).
      and_return("l'Information")
  end

  it "does not add HTMLEntities to the FOI law title" do
    allow(request).to receive(:legislation).and_return(
      FactoryBot.build(:legislation, full: "Test's Law")
    )
    assign(:info_request, request)
    render
    expect(response).to match("the Test's Law request")
  end

  it "does not add HTMLEntities to the request title" do
    assign(:info_request, request)
    render
    expect(response).to match("request Request apostrophe's data that you made")
  end

  it "does not add HTMLEntities to the public body name" do
    assign(:info_request, request)
    render
    expect(response).to match("that you made to Apostrophe's,")
  end

  it "does not add HTMLEntities to the display status" do
    allow(request).to receive(:display_status).and_return("Isn't FOI")
    assign(:info_request, request)
    render
    expect(response).to match("isn't foi")
  end

  it "does not add HTMLEntities to the site name" do
    assign(:info_request, request)
    render
    expect(response).to match("the l'Information team")
  end
end
