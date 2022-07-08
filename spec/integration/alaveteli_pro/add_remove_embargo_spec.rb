require 'spec_helper'
require 'integration/alaveteli_dsl'

RSpec.describe 'Adding/removing embargoes from requests' do

  let(:pro_user) { FactoryBot.create(:pro_user) }
  let(:user) { FactoryBot.create(:user) }
  let!(:user_session) { login(user) }

  describe "adding an embargo to a request" do

    let!(:info_request) do
      FactoryBot.create(:info_request, user: pro_user,
                                       title: 'My awesome request')
    end

    it 'removes the request from the search results' do
      update_xapian_index

      using_session(user_session) do
        visit frontpage_path
        fill_in "navigation_search_button", with: 'awesome'
        click_button "Search"
        expect(page).to have_content(info_request.title)
      end

      # add the embargo
      FactoryBot.create(:embargo, info_request: info_request)

      update_xapian_index

      using_session(user_session) do
        visit frontpage_path
        fill_in "navigation_search_button", with: 'awesome'
        click_button "Search"
        expect(page).not_to have_content(info_request.title)
      end
    end

  end

  describe 'removing an embargo from a request' do

    let!(:info_request) do
      request = FactoryBot.create(:info_request, user: pro_user,
                                                 title: 'My embargoed request')
      FactoryBot.create(:embargo, info_request: request)
      request
    end

    it 'adds the request to the search results' do
      update_xapian_index

      using_session(user_session) do
        visit frontpage_path
        fill_in "navigation_search_button", with: 'embargoed'
        click_button "Search"
        expect(page).not_to have_content(info_request.title)
      end

      # destroy the embargo
      info_request.embargo.destroy

      update_xapian_index

      using_session(user_session) do
        visit frontpage_path
        fill_in "navigation_search_button", with: 'embargoed'
        click_button "Search"
        expect(page).to have_content(info_request.title)
      end
    end

  end
end
