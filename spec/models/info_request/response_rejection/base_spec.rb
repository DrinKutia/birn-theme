require 'spec_helper'

RSpec.describe InfoRequest::ResponseRejection::Base do

  describe '.new' do

    it 'requires an info_request' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it 'requires an email' do
      expect { described_class.new(double('info_request')) }.
        to raise_error(ArgumentError)
    end

    it 'requires a raw_email_data' do
      expect { described_class.new(double('info_request'), double('email')) }.
        to raise_error(ArgumentError)
    end

    it 'assigns the info_request' do
      info_request = FactoryBot.build(:info_request)
      args = [info_request, double('email'), double('raw_email_data')]
      rejection = described_class.new(*args)
      expect(rejection.info_request).to eq(info_request)
    end

    it 'assigns the email' do
      info_request = FactoryBot.build(:info_request)
      email = double('email')
      args = [info_request, email, double('raw_email_data')]
      rejection = described_class.new(*args)
      expect(rejection.email).to eq(email)
    end

    it 'assigns the raw_email_data' do
      info_request = FactoryBot.build(:info_request)
      raw_email_data = double('raw_email_data')
      args = [info_request, double('email'), raw_email_data]
      rejection = described_class.new(*args)
      expect(rejection.raw_email_data).to eq(raw_email_data)
    end

  end

  describe '#reject' do

    it 'returns true' do
      args = [double('info_request'), double('email'), double('raw_email_data')]
      rejection = described_class.new(*args)
      expect(rejection.reject).to eq(true)
    end

    it 'accepts a rejection reason' do
      args = [double('info_request'), double('email'), double('raw_email_data')]
      rejection = described_class.new(*args)
      expect(rejection.reject('')).to eq(true)
    end

  end

end
