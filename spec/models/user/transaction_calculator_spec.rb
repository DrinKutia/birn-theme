require 'spec_helper'

RSpec.describe User::TransactionCalculator do

  let(:user) { FactoryBot.create(:user) }

  subject { described_class.new(user) }

  describe '.new' do

    it 'requires a User' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it 'sets a list of default transaction associations' do
      list = described_class::DEFAULT_TRANSACTION_ASSOCIATIONS
      expect(described_class.new(user).transaction_associations).to eq(list)
    end

    it 'allows a list of custom transaction associations' do
      list = [:comments, :info_requests]
      calc = described_class.new(user, :transaction_associations => list)
      expect(calc.transaction_associations).to eq(list)
    end

    it 'raises an error if a transaction association is invalid' do
      list = [:invalid_method, :info_requests]
      expect {
        described_class.new(user, :transaction_associations => list)
      }.to raise_error(NoMethodError)
    end

  end

  describe '#user' do

    it 'returns the User' do
      expect(subject.user).to eq(user)
    end

  end

  describe '#total' do

    context 'with no arguments' do

      it 'sums the total transactions made by the user' do
        3.times do
          FactoryBot.create(:comment, :user => user)
          FactoryBot.create(:info_request, :user => user)
        end
        expect(subject.total).to eq(6)
      end

    end

    context 'with a Range argument' do

      it 'sums the total transactions made by the user during the range' do
        travel_to(1.year.ago) do
          FactoryBot.create(:comment, :user => user)
          FactoryBot.create(:info_request, :user => user)
        end

        travel_to(3.days.ago) do
          FactoryBot.create(:comment, :user => user)
          FactoryBot.create(:info_request, :user => user)
        end

        FactoryBot.create(:comment, :user => user)

        expect(subject.total(10.days.ago..1.day.ago)).to eq(2)
      end

    end

    context 'with a Symbol argument' do

      it ':last_7_days sums the total transactions made by the user in the last 7 days' do
        travel_to(8.days.ago) do
          FactoryBot.create(:comment, :user => user)
        end

        travel_to(7.days.ago) do
          FactoryBot.create(:comment, :user => user)
        end

        travel_to(6.days.ago) do
          FactoryBot.create(:comment, :user => user)
        end

        expect(subject.total(:last_7_days)).to eq(2)
      end

      it ':last_30_days sums the total transactions made by the user in the last 30 days' do
        travel_to(31.days.ago) do
          FactoryBot.create(:comment, :user => user)
        end

        travel_to(30.days.ago) do
          FactoryBot.create(:comment, :user => user)
        end

        travel_to(29.days.ago) do
          FactoryBot.create(:comment, :user => user)
        end

        expect(subject.total(:last_30_days)).to eq(2)
      end

      it ':last_quarter sums the total transactions made by the user in the last quarter' do
        travel_to(Time.zone.parse('2014-12-31')) do
          FactoryBot.create(:comment, :user => user)
        end

        travel_to(Time.zone.parse('2015-01-01')) do
          FactoryBot.create(:comment, :user => user)
        end

        travel_to(Time.zone.parse('2015-03-31')) do
          FactoryBot.create(:comment, :user => user)
        end

        travel_to(Time.zone.parse('2015-04-01')) do
          FactoryBot.create(:comment, :user => user)
        end

        travel_to(Time.zone.parse('2015-04-01')) do
          expect(subject.total(:last_quarter)).to eq(2)
        end
      end

      it 'raises an ArgumentError if the named range is invalid' do
        expect { subject.total(:invalid_range) }.
          to raise_error(ArgumentError, "Invalid range `:invalid_range'")
      end
    end

    it 'raises an ArgumentError if the argument is invalid' do
      expect { subject.total('invalid argument') }.
        to raise_error(ArgumentError, "Invalid argument `invalid argument'")
    end

  end

  describe '#total_per_month' do

    it 'returns a hash containing the total transactions grouped by month' do
      travel_to(Time.zone.parse('2016-01-05')) do
        FactoryBot.create(:comment, :user => user)
      end

      travel_to(Time.zone.parse('2016-01-05')) do
        FactoryBot.create(:info_request, :user => user)
      end

      travel_to(Time.zone.parse('2016-01-05') + 1.hour) do
        FactoryBot.create(:info_request, :user => user)
      end

      travel_to(Time.zone.parse('2016-03-06')) do
        FactoryBot.create(:comment, :user => user)
      end

      expect(subject.total_per_month).
        to eq({ '2016-01-01' => 3, '2016-03-01' => 1 })
    end

  end

  describe '#average_per_month' do

    it 'returns the average transactions per month' do
      travel_to(Time.zone.parse('2016-01-01'))
      user = FactoryBot.create(:user)
      travel_back

      travel_to(Time.zone.parse('2016-02-01')) do
        3.times { FactoryBot.create(:comment, :user => user) }
      end

      travel_to(Time.zone.parse('2016-04-01')) do
        3.times { FactoryBot.create(:comment, :user => user) }
      end

      subject = described_class.new(user)

      travel_to(Time.zone.parse('2016-04-30')) do
        expect(subject.average_per_month).to eq(1.5)
      end
    end

  end

  describe '#==' do

    it 'returns true if the user and transactions are equal' do
      expect(described_class.new(user)).to eq(described_class.new(user))
    end

    it 'returns true if the transactions are in a different order' do
      list1 = [:comments, :info_requests]
      list2 = [:info_requests, :comments]
      calc1 = described_class.new(user, :transaction_associations => list1)
      calc2 = described_class.new(user, :transaction_associations => list2)
      expect(calc1).to eq(calc2)
    end

    it 'returns false if the user is different' do
      expect(described_class.new(user)).not_to eq(described_class.new(User.new))
    end

    it 'returns false if the transactions are different' do
      list1 = [:comments, :info_requests]
      list2 = [:comments]
      calc1 = described_class.new(user, :transaction_associations => list1)
      calc2 = described_class.new(user, :transaction_associations => list2)
      expect(calc1).not_to eq(calc2)
    end

  end

end
