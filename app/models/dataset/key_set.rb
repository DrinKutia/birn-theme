# == Schema Information
# Schema version: 20210114161442
#
# Table name: dataset_key_sets
#
#  id            :bigint           not null, primary key
#  resource_type :string
#  resource_id   :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

##
# A dataset collection of keys
#
class Dataset::KeySet < ApplicationRecord
  belongs_to :resource, polymorphic: true
  has_many :keys, foreign_key: 'dataset_key_set_id', inverse_of: :key_set
  has_many :value_sets, foreign_key: 'dataset_key_set_id', inverse_of: :key_set

  RESOURCE_TYPES = %w[
    Project
    InfoRequest
    InfoRequestBatch
  ].freeze

  validates :resource, presence: true
  validates :resource_type, inclusion: { in: RESOURCE_TYPES }
end
