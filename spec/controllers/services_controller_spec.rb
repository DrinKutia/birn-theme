require 'spec_helper'

RSpec.describe ServicesController do

  render_views

  describe '#other_country_message' do

    # store and restore the locale in the context of the test suite to isolate
    # changes made in these tests
    before do
      @old_locale = FastGettext.locale
    end

    after do
      FastGettext.set_locale(@old_locale)
    end

    it 'keeps the flash' do
      # Make two get requests to simulate the flash getting swept after the
      # first response.
      get :other_country_message, flash: { :some_flash_key => 'abc' }
      get :other_country_message
      expect(flash[:some_flash_key]).to eq('abc')
    end

    it "shows no alaveteli message when user in same country as deployed alaveteli" do
      allow(AlaveteliConfiguration).
        to receive(:iso_country_code).and_return("DE")
      allow(controller).to receive(:country_from_ip).and_return('DE')
      get :other_country_message
      expect(response.body).to eq("")
    end

    it "shows a message if user location has a deployed FOI website" do
      allow(AlaveteliConfiguration).
        to receive(:iso_country_code).and_return("ZZ")
      allow(controller).to receive(:country_from_ip).and_return('DE')
      get :other_country_message
      expect(response.body).
        to match(/requests within Deutschland at/)
    end

    context 'when user not in the same country as site' do

      it "shows a message when user country has no FOI website" do
        allow(AlaveteliConfiguration).
          to receive(:iso_country_code).and_return("DE")
        allow(controller).to receive(:country_from_ip).and_return('ZZ')
        get :other_country_message
        expect(response.body).to match(/outside Deutschland/)
      end

      it "shows a message when user country has no FOI website and WorldFOIWebsites has no data about the deployed alaveteli" do
        allow(AlaveteliConfiguration).
          to receive(:iso_country_code).and_return("XY")
        allow(controller).to receive(:country_from_ip).and_return('ZZ')
        get :other_country_message
        expect(response.body).to match(/in other countries/)
      end

      it "shows an EU message if the user location has a deployed FOI website and is covered by AskTheEU" do
        allow(AlaveteliConfiguration).
          to receive(:iso_country_code).and_return("DE")
        allow(controller).to receive(:country_from_ip).and_return('GB')
        get :other_country_message
        expect(response.body).to match(/within United Kingdom at/)
        expect(response.body).to match(/EU institutions/)
      end

      it "shows a message when user country has no FOI website but user country is covered by EU" do
        allow(AlaveteliConfiguration).
          to receive(:iso_country_code).and_return("DE")
        allow(controller).to receive(:country_from_ip).and_return('MT')
        get :other_country_message
        expect(response.body).to match(/outside Deutschland/)
        expect(response.body).to match(/EU institutions/)
      end

      it "shows a message when and user country has no FOI website and WorldFOIWebsites has no data about the deployed alaveteli but user is covered by EU" do
        allow(AlaveteliConfiguration).
          to receive(:iso_country_code).and_return("XY")
        allow(controller).to receive(:country_from_ip).and_return('MT')
        get :other_country_message
        expect(response.body).to match(/in other countries/)
        expect(response.body).to match(/EU institutions/)
      end

    end

  end

  describe '#hidden_user_explanation' do

    let(:user) { FactoryBot.create(:user, name: "P O'Toole") }
    let(:info_request) { FactoryBot.create(:info_request, user: user) }

    it 'generates plaintext output' do
      get :hidden_user_explanation,
          params: { info_request_id: info_request.id, message: 'not_foi' }
      expect(response.media_type).to eq 'text/plain'
    end

    it 'does not HTML escape the user or site name' do
      allow(AlaveteliConfiguration).
        to receive(:site_name).and_return('A&B Test')
      get :hidden_user_explanation,
          params: { info_request_id: info_request.id, message: 'not_foi' }
      expect(response.body).to match(/Dear P O'Toole/)
      expect(response.body).to match(/Yours,\n\nThe A&B Test team/)
    end

  end

end
