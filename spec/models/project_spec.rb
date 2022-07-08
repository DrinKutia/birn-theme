# == Schema Information
# Schema version: 20210114161442
#
# Table name: projects
#
#  id           :bigint           not null, primary key
#  title        :string
#  briefing     :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  invite_token :string
#

require 'spec_helper'

RSpec.describe Project, type: :model, feature: :projects do
  subject(:project) { FactoryBot.build_stubbed(:project) }

  shared_context 'project with resources' do
    let(:project) do
      FactoryBot.create(:project, requests: [request], batches: [batch])
    end

    let(:request) { FactoryBot.build(:info_request) }
    let(:batch) { FactoryBot.build(:info_request_batch, :sent) }
  end

  shared_context 'non-project resources' do
    let!(:other_request) { FactoryBot.create(:info_request) }
    let!(:other_batch) { FactoryBot.create(:info_request_batch, :sent) }
  end

  shared_context 'project with submitted requests' do
    let(:project) do
      FactoryBot.create(
        :project, requests: [
          unclassified_request, classified_request, extracted_request
        ]
      )
    end

    let(:unclassified_request) { FactoryBot.build(:info_request) }
    let(:classified_request) do
      FactoryBot.build(
        :info_request,
        awaiting_description: false,
        described_state: 'successful'
      )
    end
    let(:extracted_request) { FactoryBot.build(:info_request) }

    before do
      FactoryBot.create(
        :project_submission, :for_classification,
        project: project, info_request: classified_request
      )
      FactoryBot.create(
        :project_submission, :for_extraction,
        project: project, info_request: extracted_request
      )
    end
  end

  describe 'associations' do
    subject(:project) do
      FactoryBot.create(
        :project,
        :with_key_set,
        owner: owner,
        contributors_count: 2, requests_count: 2, batches_count: 2
      )
    end

    let(:owner) { FactoryBot.build(:pro_user) }

    it 'has many members' do
      expect(project.members).to all be_a(User)
      expect(project.members).to include(owner)
      expect(project.members.count).to eq 3
    end

    it 'has one owner' do
      expect(project.owner).to be_a User
      expect(project.owner).to eq owner
    end

    it 'has many contributors' do
      expect(project.contributors).to all be_a(User)
      expect(project.contributors).not_to include owner
      expect(project.contributors.count).to eq 2
    end

    it 'has many resources' do
      expect(project.resources).to all be_a(Project::Resource)
      expect(project.resources.count).to eq 4
    end

    it 'has many requests' do
      expect(project.requests).to all be_a(InfoRequest)
      expect(project.requests.count).to eq 2
    end

    it 'has many batches' do
      expect(project.batches).to all be_a(InfoRequestBatch)
      expect(project.batches.count).to eq 2
    end

    context 'has many info_requests' do
      include_context 'project with resources'
      include_context 'non-project resources'

      subject { project.info_requests }

      it 'returns array of InfoRequest' do
        is_expected.to all be_an(InfoRequest)
      end

      it 'includes requests' do
        is_expected.to include request
      end

      it 'excludes non-project requests' do
        is_expected.not_to include other_request
      end

      it 'includes batch requests' do
        is_expected.to include(*batch.info_requests)
      end

      it 'excludes non-project batch requests' do
        is_expected.not_to include(*other_batch.info_requests)
      end
    end

    it 'has one key set' do
      expect(project.key_set).to be_a(Dataset::KeySet)
    end
  end

  describe 'validations' do
    it { is_expected.to be_valid }

    it 'requires title' do
      project.title = nil
      is_expected.not_to be_valid
    end

    it 'requires owner' do
      project.owner = nil
      is_expected.not_to be_valid
    end
  end

  describe '#info_request?' do
    include_context 'project with resources'
    include_context 'non-project resources'

    subject { project.info_request?(resource) }

    context 'given an project info request' do
      let(:resource) { request }
      it { is_expected.to eq(true) }
    end

    context 'given an project batch info request' do
      let(:resource) { batch.info_requests.first }
      it { is_expected.to eq(true) }
    end

    context 'given an non-project info request' do
      let(:resource) { other_request }
      it { is_expected.to eq(false) }
    end

    context 'given an non-project batch info request' do
      let(:resource) { other_batch.info_requests.first }
      it { is_expected.to eq(false) }
    end
  end

  describe '#owner?' do
    subject { project.owner?(user) }

    let(:owner) { FactoryBot.create(:user) }
    let(:contributor) { FactoryBot.create(:user) }
    let(:non_member) { FactoryBot.create(:user) }

    let(:project) do
      project = FactoryBot.create(:project, owner: owner)
      project.contributors << contributor
      project
    end

    context 'given an owner' do
      let(:user) { owner }
      it { is_expected.to eq(true) }
    end

    context 'given a contributor' do
      let(:user) { contributor }
      it { is_expected.to eq(false) }
    end

    context 'given a non-member' do
      let(:user) { non_member }
      it { is_expected.to eq(false) }
    end
  end

  describe '#member?' do
    subject { project.member?(user) }

    let(:owner) { FactoryBot.create(:user) }
    let(:contributor) { FactoryBot.create(:user) }
    let(:non_member) { FactoryBot.create(:user) }

    let(:project) do
      project = FactoryBot.create(:project, owner: owner)
      project.contributors << contributor
      project
    end

    context 'given an owner' do
      let(:user) { owner }
      it { is_expected.to eq(true) }
    end

    context 'given a contributor' do
      let(:user) { contributor }
      it { is_expected.to eq(true) }
    end

    context 'given a non-member' do
      let(:user) { non_member }
      it { is_expected.to eq(false) }
    end
  end

  describe '#contributor?' do
    subject { project.contributor?(user) }

    let(:owner) { FactoryBot.create(:user) }
    let(:contributor) { FactoryBot.create(:user) }
    let(:non_member) { FactoryBot.create(:user) }

    let(:project) do
      project = FactoryBot.create(:project, owner: owner)
      project.contributors << contributor
      project
    end

    context 'given an owner' do
      let(:user) { owner }
      it { is_expected.to eq(false) }
    end

    context 'given a contributor' do
      let(:user) { contributor }
      it { is_expected.to eq(true) }
    end

    context 'given a non-member' do
      let(:user) { non_member }
      it { is_expected.to eq(false) }
    end
  end

  describe '#info_requests.classifiable' do
    subject { project.info_requests.classifiable }

    let(:classifiable_request) { FactoryBot.create(:awaiting_description) }
    let(:non_classifiable_request) { FactoryBot.create(:successful_request) }

    let(:project) do
      project = FactoryBot.create(:project)
      project.requests << [classifiable_request, non_classifiable_request]
      project
    end

    it { is_expected.to match_array([classifiable_request]) }
  end

  describe '#info_requests.classified' do
    subject { project.info_requests.classified }

    let(:classifiable_request) { FactoryBot.create(:awaiting_description) }
    let(:classified_request) { FactoryBot.create(:successful_request) }

    let(:project) do
      project = FactoryBot.create(:project)
      project.requests << [classifiable_request, classified_request]
      project
    end

    it { is_expected.to match_array([classified_request]) }
  end

  describe '#classification_progress' do
    subject { project.classification_progress }

    before do
      allow(project).to receive(:info_requests).and_return(
        double(count: 3, classified: double(count: 2))
      )
    end

    it { is_expected.to eq(66) }

    context 'when there are no requests' do
      before do
        allow(project).to receive(:info_requests).and_return(double(count: 0))
      end

      it { is_expected.to eq(0) }
    end
  end

  describe '#info_requests.extractable' do
    include_context 'project with submitted requests'

    subject { project.info_requests.extractable }

    it 'returns array of InfoRequest' do
      is_expected.to all be_an(InfoRequest)
    end

    it 'excludes unclassified_request requests' do
      is_expected.not_to include unclassified_request
    end

    it 'includes extractable requests' do
      is_expected.to include classified_request
    end

    it 'excludes extracted requests' do
      is_expected.not_to include extracted_request
    end
  end

  describe '#info_requests.extracted' do
    include_context 'project with submitted requests'

    subject { project.info_requests.extracted }

    it 'returns array of InfoRequest' do
      is_expected.to all be_an(InfoRequest)
    end

    it 'excludes unclassified_request requests' do
      is_expected.not_to include unclassified_request
    end

    it 'excludes classified requests' do
      is_expected.not_to include classified_request
    end

    it 'includes extracted requests' do
      is_expected.to include extracted_request
    end
  end

  describe '#extraction_progress' do
    subject { project.extraction_progress }

    before do
      allow(project).to receive(:info_requests).and_return(
        double(extractable: double(count: 1), extracted: double(count: 2))
      )
    end

    it { is_expected.to eq(66) }

    context 'when there are no extractable or extracted requests' do
      before do
        allow(project).to receive(:info_requests).and_return(
          double(extractable: double(count: 0), extracted: double(count: 0))
        )
      end

      it { is_expected.to eq(0) }
    end
  end
end
