require 'spec_helper'

RSpec.describe OneTimePasswordsController do

  before :each do
    allow(AlaveteliConfiguration).
      to receive(:enable_two_factor_auth).and_return(true)
  end

  describe 'GET show' do

    it 'redirects to the sign-in page without a signed in user' do
      get :show

      expect(response).
        to redirect_to(signin_path(:token => PostRedirect.last.token))
    end

    it 'assigns the signed in user' do
      user = FactoryBot.create(:user)

      sign_in user
      get :show

      expect(assigns[:user]).to eq(user)
    end

    it 'renders the show template' do
      user = FactoryBot.create(:user)

      sign_in user
      get :show

      expect(response).to render_template('show')
    end

    context 'when 2factor auth is not enabled' do

      it 'raises ActiveRecord::RecordNotFound' do
        allow(AlaveteliConfiguration).
          to receive(:enable_two_factor_auth).and_return(false)
        expect {
          get :show
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

  describe 'POST #create' do

    it 'redirects to the sign-in page without a signed in user' do
      post :create
      expect(response).
        to redirect_to(signin_path(:token => PostRedirect.last.token))
    end

    it 'assigns the signed in user' do
      user = FactoryBot.create(:user)
      sign_in user
      post :create
      expect(assigns[:user]).to eq(user)
    end

    it 'enables OTP for the user' do
      user = FactoryBot.create(:user)
      sign_in user
      post :create
      expect(user.reload.otp_enabled?).to eq(true)
    end

    it 'does not disable OTP for the user' do
      user = FactoryBot.create(:user)
      user.enable_otp
      user.save!
      sign_in user
      post :create
      expect(user.reload.otp_enabled?).to eq(true)
    end

    it 'sets a successful notification message' do
      user = FactoryBot.create(:user)
      sign_in user
      post :create
      expect(flash[:notice]).to eq('Two factor authentication enabled')
    end

    it 'redirects back to #show on success' do
      user = FactoryBot.create(:user)
      sign_in user
      post :create
      expect(response).to redirect_to(one_time_password_path)
    end

    it 'renders #show on failure' do
      allow_any_instance_of(User).to receive(:save).and_return(false)
      user = FactoryBot.create(:user)
      sign_in user
      post :create
      expect(response).to render_template(:show)
    end

    it 'sets a failure notification message' do
      allow_any_instance_of(User).to receive(:save).and_return(false)
      user = FactoryBot.create(:user)
      sign_in user
      post :create
      expect(flash[:error]).
        to eq('Two factor authentication could not be enabled')
    end

    context 'when 2factor auth is not enabled' do

      it 'raises ActiveRecord::RecordNotFound' do
        allow(AlaveteliConfiguration).
          to receive(:enable_two_factor_auth).and_return(false)
        expect {
          post :create
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

  describe 'PUT #update' do

    it 'redirects to the sign-in page without a signed in user' do
      put :update
      expect(response).
        to redirect_to(signin_path(:token => PostRedirect.last.token))
    end

    it 'assigns the signed in user' do
      user = FactoryBot.create(:user)
      sign_in user
      put :update
      expect(assigns[:user]).to eq(user)
    end

    it 'regenerates the otp_code' do
      user = FactoryBot.create(:user, :otp_enabled => true)
      expected = ROTP::HOTP.new(user.otp_secret_key).at(2)
      sign_in user
      put :update
      expect(user.reload.otp_code).to eq(expected)
    end

    it 'sets a successful notification message' do
      user = FactoryBot.create(:user, :otp_enabled => true)
      sign_in user
      put :update
      expect(flash[:notice]).to eq('Two factor one time passcode updated')
    end

    it 'redirects back to #show on success' do
      user = FactoryBot.create(:user, :otp_enabled => true)
      sign_in user
      put :update
      expect(response).to redirect_to(one_time_password_path)
    end

    it 'renders #show on failure' do
      user = FactoryBot.create(:user, :otp_enabled => true)
      allow_any_instance_of(User).
        to receive(:increment!).and_return(false)
      sign_in user
      put :update
      expect(response).to render_template(:show)
    end

    it 'warns the user on failure' do
      user = FactoryBot.create(:user, :otp_enabled => true)
      allow_any_instance_of(User).
        to receive(:increment!).and_return(false)
      sign_in user
      put :update
      expect(flash[:error]).
        to eq('Could not update your two factor one time passcode')
    end

    context 'when 2factor auth is not enabled' do

      it 'raises ActiveRecord::RecordNotFound' do
        allow(AlaveteliConfiguration).
          to receive(:enable_two_factor_auth).and_return(false)
        expect {
          put :update
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

  describe 'DELETE #destroy' do

    it 'redirects to the sign-in page without a signed in user' do
      user = FactoryBot.create(:user)
      delete :destroy
      expect(response).
        to redirect_to(signin_path(:token => PostRedirect.last.token))
    end

    it 'assigns the signed in user' do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy
      expect(assigns[:user]).to eq(user)
    end

    it 'disables OTP for the user' do
      user = FactoryBot.create(:user)
      user.enable_otp
      user.save!
      sign_in user
      delete :destroy
      expect(user.reload.otp_enabled?).to eq(false)
    end

    it 'sets a successful notification message' do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy
      expect(flash[:notice]).to eq('Two factor authentication disabled')
    end

    it 'redirects back to #show on success' do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy
      expect(response).to redirect_to(one_time_password_path)
    end

    it 'sets a failure notification message' do
      allow_any_instance_of(User).to receive(:save).and_return(false)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy
      expect(flash[:error]).
        to eq('Two factor authentication could not be disabled')
    end

    it 'renders #show on failure' do
      allow_any_instance_of(User).to receive(:save).and_return(false)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy
      expect(response).to render_template(:show)
    end

    context 'when two factor auth is not enabled' do

      it 'raises ActiveRecord::RecordNotFound' do
        allow(AlaveteliConfiguration).
          to receive(:enable_two_factor_auth).and_return(false)
        expect {
          delete :destroy
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

end
