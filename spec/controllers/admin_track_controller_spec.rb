require 'spec_helper'

RSpec.describe AdminTrackController do

  describe 'GET index' do

    it "shows the index page" do
      get :index
      expect(response).to render_template("index")
    end

    describe 'POST destroy' do
      let(:track) { FactoryBot.create(:track_thing) }

      it 'destroys the track' do
        post :destroy, params: { id: track.id }
        expect(TrackThing.where(id: track.id)).to be_empty
      end

    end

  end
end
