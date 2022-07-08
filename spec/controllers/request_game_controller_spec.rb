require 'spec_helper'

RSpec.describe RequestGameController do

  describe "GET play" do

    it "shows the game homepage" do
      get :play
      expect(response).to render_template('play')
    end

    it 'assigns three old unclassified requests' do
      InfoRequest.destroy_all
      requests = []
      3.times do
        requests << FactoryBot.create(:old_unclassified_request)
      end
      get :play
      expect(assigns[:requests]).to match_array(requests)
    end

    it 'assigns the number of unclassified requests' do
      InfoRequest.destroy_all
      FactoryBot.create(:old_unclassified_request)
      get :play
      expect(assigns[:missing]).to eq(1)
    end

    context 'there are no requests' do

      before do
        InfoRequest.destroy_all
      end

      it 'shows the game homepage' do
        get :play
        expect(response).to render_template('play')
      end

    end

    context 'there are no old unclassified requests' do

      before do
        InfoRequest.destroy_all
        FactoryBot.create(:info_request)
      end

      render_views

      let(:test_url) { help_credits_path(:anchor => "helpus") }

      it 'shows the game homepage' do
        get :play
        expect(response).to render_template('play')
      end

      it 'assigns the game_over template to the flash message' do
        get :play
        expect(flash.now[:notice][:partial]).
          to eq("request_game/game_over.html.erb")
        expect(flash.now[:notice][:locals]).to include({
          :helpus_url => test_url,
          :site_name => site_name
        })
      end

      it 'displays the flash message' do
        get :play
        expect(response.body).to have_css('div#notice p')
        expect(response.body).
          to have_content('All done! Thank you very much for your help')
        expect(response.body).
          to have_link('more things you can do', :href => test_url)
      end

    end

  end

end
