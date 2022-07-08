require 'spec_helper'
require 'integration/alaveteli_dsl'

RSpec.describe 'Editing a Public Body' do
  before do
    allow(AlaveteliConfiguration).to receive(:skip_admin_auth).and_return(false)

    confirm(:admin_user)
    @admin = login(:admin_user)

    PublicBody.create(:name => 'New Quango',
                      :short_name => '',
                      :request_email => 'newquango@localhost',
                      :last_edit_editor => 'test',
                      :last_edit_comment => 'testing')

    @body = PublicBody.find_by_name('New Quango')
  end

  it 'can edit the default locale' do
    using_session(@admin) do
      visit edit_admin_body_path(@body)
      fill_in 'public_body_name', :with => 'New Quango EN'
      click_button 'Save'
    end
    pb = @body.reload
    expect(pb.name).to eq('New Quango EN')
  end

  it 'can add a translation for a single locale' do
    expect(@body.find_translation_by_locale('fr')).to be_nil
    using_session(@admin) do
      visit edit_admin_body_path(@body)
      fill_in 'public_body_translations_attributes_fr_name', :with => 'New Quango FR'
      click_button 'Save'
    end
    pb = @body.reload
    AlaveteliLocalization.with_locale(:fr) do
      expect(pb.name).to eq('New Quango FR')
    end
  end

  it 'can add a translation for multiple locales' do
    using_session(@admin) do
      visit edit_admin_body_path(@body)
      fill_in 'public_body_name', :with => 'New Quango EN'
      click_button 'Save'

      # Add FR translation
      expect(@body.find_translation_by_locale('fr')).to be_nil
      visit edit_admin_body_path(@body)
      fill_in 'public_body_translations_attributes_fr_name', :with => 'New Quango FR'
      click_button 'Save'

      # Add ES translation
      expect(@body.find_translation_by_locale('es')).to be_nil
      visit edit_admin_body_path(@body)
      fill_in 'public_body_translations_attributes_es_name', :with => 'New Quango ES'
      click_button 'Save'
    end
    pb = @body.reload

    expect(pb.name).to eq('New Quango EN')

    AlaveteliLocalization.with_locale(:fr) do
      expect(pb.name).to eq('New Quango FR')
    end

    AlaveteliLocalization.with_locale(:es) do
      expect(pb.name).to eq('New Quango ES')
    end
  end
end
