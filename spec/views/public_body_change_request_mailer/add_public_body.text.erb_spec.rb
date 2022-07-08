require 'spec_helper'

RSpec.describe 'public_body_change_request_mailer/add_public_body' do
  let(:user) { FactoryBot.create(:user, name: "Test Us'r") }

  let(:change_request) do
    FactoryBot.create(
      :add_body_request,
      public_body_name: "Apostrophe's",
      user: user,
      notes: "Meeting starts at 12 o'clock")
  end

  before do
    allow(AlaveteliConfiguration).to receive(:site_name).
      and_return("l'Information")

    assign(:change_request, change_request)
    render
  end

  it 'does not add HTMLEntities to the user name' do
    expect(response).to match("Test Us'r would like a new authority added")
  end

  it 'does not add HTMLEntities to the site name' do
    expect(response).to match("new authority added to l'Information")
  end

  it 'does not add HTMLEntities to the public body name' do
    expect(response).to match("Authority:\nApostrophe's")
  end

end
