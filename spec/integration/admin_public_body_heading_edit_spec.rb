require 'spec_helper'
require 'integration/alaveteli_dsl'

RSpec.describe 'Editing a Public Body Heading' do
  before do
    allow(AlaveteliConfiguration).to receive(:skip_admin_auth).and_return(false)

    confirm(:admin_user)
    @admin = login(:admin_user)
    @heading = FactoryBot.create(:public_body_heading)
  end

  it 'can edit the default locale' do
    using_session(@admin) do
      visit edit_admin_heading_path(@heading)
      fill_in 'public_body_heading_name', :with => 'New Heading EN'
      click_button 'Save'
    end
    @heading.reload
    expect(@heading.name).to eq('New Heading EN')
  end

  it 'can add a translation for a single locale' do
    expect(@heading.find_translation_by_locale('fr')).to be_nil
    using_session(@admin) do
      visit edit_admin_heading_path(@heading)
      fill_in 'public_body_heading_translations_attributes_fr_name', :with => 'New Heading FR'
      click_button 'Save'
    end
    @heading.reload
    AlaveteliLocalization.with_locale(:fr) do
      expect(@heading.name).to eq('New Heading FR')
    end
  end

  it 'can add a translation for multiple locales' do
    using_session(@admin) do
      # Add FR translation
      expect(@heading.find_translation_by_locale('fr')).to be_nil
      visit edit_admin_heading_path(@heading)
      fill_in 'public_body_heading_translations_attributes_fr_name', :with => 'New Heading FR'
      click_button 'Save'

      # Add ES translation
      expect(@heading.find_translation_by_locale('es')).to be_nil
      visit edit_admin_heading_path(@heading)
      fill_in 'public_body_heading_translations_attributes_es_name', :with => 'New Heading ES'
      click_button 'Save'
    end

    @heading.reload
    AlaveteliLocalization.with_locale(:fr) do
      expect(@heading.name).to eq('New Heading FR')
    end

    AlaveteliLocalization.with_locale(:es) do
      expect(@heading.name).to eq('New Heading ES')
    end
  end

end
