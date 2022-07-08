require 'spec_helper'

RSpec.describe Users::MessagesController do

  render_views

  let(:sender) { FactoryBot.create(:user, name: 'Bob Smith') }
  let(:recipient) { FactoryBot.create(:user) }

  before { sign_in sender }

  describe 'GET contact' do

    context 'when not signed in' do

      it 'redirects to signin page' do
        sign_in nil
        get :contact, params: { url_name: recipient.url_name }
        expect(response).
          to redirect_to(signin_path(token: get_last_post_redirect.token))
      end

    end

    it 'shows the contact form' do
      get :contact, params: { url_name: recipient.url_name }
      expect(response).to render_template('contact')
    end

    it 'raises an error if the recipient user is not found' do
      expect {
        get :contact, params: { url_name: 'not-known-at-this-address' }
      }.to raise_error ActiveRecord::RecordNotFound
    end

  end

  describe 'POST contact' do

    it 'shows an error if not given a subject line' do
      post :contact, params: {
                       url_name: recipient.url_name,
                       contact: {
                         subject: '',
                         message: 'Gah'
                       },
                       submitted_contact_form: 1
                     }
      expect(response).to render_template('contact')
    end

    context 'the site is configured to require a captcha' do
      before do
        allow(AlaveteliConfiguration).
          to receive(:user_contact_form_recaptcha).and_return(true)
        allow(controller).to receive(:verify_recaptcha).and_return(false)
      end

      it 'does not send the message without the recaptcha being completed' do
         post :contact, params: {
                          url_name: recipient.url_name,
                          contact: {
                            subject: 'Have some spam',
                            message: 'Spam, spam, spam'
                          },
                          submitted_contact_form: 1
                        }

         deliveries = ActionMailer::Base.deliveries
         expect(deliveries.size).to eq(0)
         deliveries.clear
       end

    end

    it 'sends the message' do
      post :contact, params: {
                       url_name: recipient.url_name,
                       contact: {
                         subject: 'Dearest you',
                         message: 'Just a test!'
                       },
                       submitted_contact_form: 1
                     }
      expect(response).to redirect_to(user_url(recipient))

      deliveries = ActionMailer::Base.deliveries
      expect(deliveries.size).to eq(1)
      mail = deliveries[0]
      expect(mail.body).
        to include("Bob Smith has used #{site_name} " \
                   "to send you the message below")
      expect(mail.body).to include('Just a test!')
      # TODO: fix some nastiness with quoting name_and_email
      # mail.to_addrs.first.to_s.should == recipient.name_and_email
      expect(mail.header['Reply-To'].to_s).to match(sender.email)
    end

  end

end
