require 'spec_helper'

RSpec.describe 'outgoing_mailer/initial_request' do
  let(:body) do
    FactoryBot.create(:public_body, name: "Apostrophe's",
                                    request_email: "a'b@example.com")
  end
  let(:request) { FactoryBot.create(:info_request, public_body: body) }
  let(:outgoing_message) { request.outgoing_messages.first }

  it 'does not add HTMLEntities to the public body name' do
    assign(:info_request, request)
    assign(:outgoing_message, outgoing_message)
    render
    expect(response).to match("requests to Apostrophe's")
  end

  it 'does not add HTMLEntities to the FOI law title' do
    allow(request).to receive(:legislation).and_return(
      FactoryBot.build(:legislation, full: "Test's Law")
    )
    assign(:info_request, request)
    assign(:outgoing_message, outgoing_message)
    render
    expect(response).
      to match("the wrong address for Test's Law requests")
  end

  it 'does not add HTMLEntities to the public body email address' do
    assign(:info_request, request)
    assign(:outgoing_message, outgoing_message)
    render
    expect(response).to match("Is a'b@example.com the wrong address")
  end
end
