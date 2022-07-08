require 'spec_helper'

RSpec.describe AlaveteliPro::ToDoList::Item do

  describe '.new' do

    it 'requires a user' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it 'assigns the user' do
      user = FactoryBot.create(:user)
      list = described_class.new(user)
      expect(list.user).to eq user
    end

  end

  describe '#count' do

    it 'returns a count of the number of items' do
      user = FactoryBot.create(:user)
      expect(described_class.new(user).count).to eq 0
    end

  end

end
