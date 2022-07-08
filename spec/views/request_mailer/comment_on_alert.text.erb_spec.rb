require 'spec_helper'

RSpec.describe "request_mailer/comment_on_alert" do
  let(:request) { FactoryBot.create(:info_request) }
  let(:user) { FactoryBot.create(:user, :name => "Test Us'r") }
  let(:comment) { FactoryBot.create(:comment, :user => user) }

  before do
    allow(AlaveteliConfiguration).to receive(:site_name).
      and_return("l'Information")
  end

  it "does not add HTMLEntities to the user name" do
    assign(:info_request, request)
    assign(:comment, comment)
    render
    expect(response).to match("Test Us'r has annotated")
  end

  it "does not add HTMLEntities to the FOI law title" do
    allow(request).to receive(:legislation).and_return(
      FactoryBot.build(:legislation, short: "Test's Law")
    )
    assign(:info_request, request)
    assign(:comment, comment)
    render
    expect(response).to match("your Test's Law request")
  end

  it "does not add HTMLEntities to the site name" do
    assign(:info_request, request)
    assign(:comment, comment)
    render
    expect(response).to match("the l'Information team")
  end
end
