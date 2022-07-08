require 'spec_helper'

RSpec.describe "user_mailer/already_registered" do

  before do
    allow(AlaveteliConfiguration).to receive(:site_name).
      and_return("l'Information")
  end

  it "does not add HTMLEntities to the site name" do
    assign(:reasons, { :email => "mailto:nospam@example.com" } )
    render
    expect(response).to match("the l'Information team")
    expect(response).to match("You just tried to sign up to l'Information")
  end

end
