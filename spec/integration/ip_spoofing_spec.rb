require 'spec_helper'

RSpec.describe 'when getting a country message' do

  it 'should not raise an IP spoofing error when given mismatched headers' do
    allow(AlaveteliConfiguration).to receive(:geoip_database).and_return(nil)
    get '/country_message', headers: {
                              'HTTP_X_FORWARDED_FOR' => '1.2.3.4',
                              'HTTP_CLIENT_IP' => '5.5.5.5'
                            }
    expect(response.status).to eq(200)
  end

end
