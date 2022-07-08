require 'spec_helper'

RSpec.describe Legislation do
  describe '.refusals=' do
    subject { described_class.refusals = refusals }

    after { described_class.refusals = nil }

    context 'when configured with refusals' do
      let(:refusals) { double.as_null_object }
      it { is_expected.to eq(refusals) }
    end

    context 'when configured after instances have been cached' do
      let(:refusals) { double.as_null_object }
      let!(:previous_instances) { described_class.all.map(&:object_id) }

      it 're-caches instances' do
        subject
        expect(described_class.all.map(&:object_id)).
          not_to eq(previous_instances)
      end
    end
  end

  describe '.refusals' do
    subject { described_class.refusals }

    before { described_class.refusals = refusals }
    after { described_class.refusals = nil }

    context 'when configured with a hash of refusals' do
      let(:refusals) do
        # rubocop:disable Style/HashSyntax
        # Explicitly tests indifferent access for keys
        { 'foi' => ['s 12', 's 14'], eir: ['s 1'] }
        # rubocop:enable Style/HashSyntax
      end

      it { is_expected.to eq(refusals.with_indifferent_access) }

      it 'has indifferent access' do
        expect(subject['eir']).to eq(['s 1'])
      end
    end
  end

  describe '.all' do
    subject { described_class.all }

    context 'when refusals have been configured' do
      before do
        described_class.refusals = { foi: ['s 12'] }
      end

      after { described_class.refusals = nil }

      context 'when the legislation has refusals' do
        it 'includes them in instance creation' do
          refusals_as_strings = described_class.find('foi').refusals.map(&:to_s)
          expect(refusals_as_strings).to include('Section 12')
        end
      end

      context 'when the legislation does not have refusals' do
        it 'sets them as empty instance creation' do
          refusals_as_strings = described_class.find('eir').refusals.map(&:to_s)
          expect(refusals_as_strings).to be_empty
        end
      end
    end

    it 'returns array of legislations objects' do
      is_expected.to all(be_a Legislation)
    end

    it 'contains FOI legislation' do
      is_expected.to include(described_class.find('foi'))
    end

    it 'contains EIR legislation' do
      is_expected.to include(described_class.find('eir'))
    end
  end

  shared_context :stub_all_legislations do
    before do
      allow(Legislation).to receive(:all).and_return(
        [legislation_1, legislation_2]
      )
    end

    let(:legislation_1) { FactoryBot.build(:legislation, key: 'abc') }
    let(:legislation_2) { FactoryBot.build(:legislation, key: 'xyz') }
  end

  describe '.find' do
    include_context :stub_all_legislations

    it 'returns legislation with a given key' do
      expect(described_class.find('abc')).to eq legislation_1
      expect(described_class.find('xyz')).to eq legislation_2
    end

    it 'returns nil if legislation can not be found for a given key' do
      expect(described_class.find('123')).to be_nil
    end
  end

  describe '.find!' do
    include_context :stub_all_legislations

    it 'returns legislation with a given key' do
      expect(described_class.find!('abc')).to eq legislation_1
      expect(described_class.find!('xyz')).to eq legislation_2
    end

    it 'returns nil if legislation can not be found for a given key' do
      expect { described_class.find!('123') }.to raise_error(
        Legislation::UnknownLegislation,
        'Unknown legislation 123.'
      )
    end
  end

  describe '.keys' do
    include_context :stub_all_legislations

    subject { described_class.keys }

    it 'returns array of legislation keys' do
      is_expected.to match_array(%w(abc xyz))
    end
  end

  describe '.default' do
    it 'finds FOI legislation' do
      expect(described_class).to receive(:find).with('foi')
      described_class.default
    end
  end

  describe '.for_public_body' do
    subject { described_class.for_public_body(public_body) }

    context 'public body tagged as eir_only' do
      let(:public_body) { FactoryBot.build(:public_body, :eir_only) }

      it 'returns array of legislations objects' do
        is_expected.to all(be_a Legislation)
      end

      it 'does not contains FOI legislation' do
        is_expected.to_not include(described_class.find('foi'))
      end

      it 'contains EIR legislation' do
        is_expected.to include(described_class.find('eir'))
      end
    end

    context 'public body not tagged as eir_only' do
      let(:public_body) { FactoryBot.build(:public_body) }

      it 'returns array of legislations objects' do
        is_expected.to all(be_a Legislation)
      end

      it 'contains FOI legislation' do
        is_expected.to include(described_class.find('foi'))
      end

      it 'contains EIR legislation' do
        is_expected.to include(described_class.find('eir'))
      end
    end
  end

  shared_context :legislation_instance do
    let(:legislation) do
      Legislation.new(key: 'key', short: 'short', full: 'full')
    end
  end

  describe 'initialisation' do
    include_context :legislation_instance

    it 'assigns key attributes' do
      expect(legislation.key).to eq 'key'
    end

    it 'assigns others attributes as variants' do
      expect(legislation.variants).to eq(
        short: 'short', full: 'full'
      )
    end
  end

  describe '#to_sym' do
    include_context :legislation_instance

    it 'returns the key as a symbol' do
      expect(legislation.to_sym).to eq :key
    end
  end

  describe '#to_s' do
    include_context :legislation_instance

    context 'without string variant' do
      it 'returns short variant' do
        expect(legislation.to_s).to eq 'short'
      end
    end

    context 'with valid string variant' do
      it 'returns given variant' do
        expect(legislation.to_s(:short)).to eq 'short'
        expect(legislation.to_s(:full)).to eq 'full'
      end
    end

    context 'with invalid string variant' do
      it 'returns nil if variant does not exist' do
        expect { legislation.to_s(:invalid) }.to raise_error(
          Legislation::UnknownLegislationVariant,
          'Unknown variant invalid in legislation key.'
        )
      end
    end
  end

  describe '#==' do
    include_context :legislation_instance

    subject { legislation == other }

    context 'when the key is the same' do
      let(:other) do
        described_class.new(key: 'key', short: 'short', full: 'full')
      end

      it { is_expected.to eq(true) }
    end

    context 'when the key is different' do
      let(:other) do
        described_class.new(key: 'bar', short: 'short', full: 'full')
      end

      it { is_expected.to eq(false) }
    end
  end

  describe '#find_references' do
    include_context :legislation_instance

    let(:text) { 'Lorem Ipsum' }

    it 'initialises a reference collection with self' do
      expect(Legislation::ReferenceCollection).to receive(:new).
        with(legislation: legislation).and_return(double.as_null_object)
      legislation.find_references(text)
    end

    it 'delegates to reference collection #match' do
      collection = double(:reference_collection)
      result = double(:return_value)
      allow(Legislation::ReferenceCollection).to receive(:new).
        and_return(collection)
      expect(collection).to receive(:match).with(text).and_return(result)
      expect(legislation.find_references(text)).to eq result
    end
  end

  describe '#refusals' do
    let(:legislation) do
      Legislation.new(key: 'key', refusals: ['s 12', 's 14'])
    end

    subject(:refusals) { legislation.refusals }

    it 'returns array of references' do
      is_expected.to be_an(Array)
      is_expected.to all(be_a(Legislation::Reference))
    end

    it 'includes the correct references' do
      refusals_as_strings = refusals.map(&:to_s)
      expect(refusals_as_strings).to include('Section 12')
      expect(refusals_as_strings).to include('Section 14')
    end

    context 'when refusals is set to nil' do
      let(:legislation) { Legislation.new(key: 'key', refusals: nil) }
      it { is_expected.to be_empty }
    end
  end
end
