# == Schema Information
# Schema version: 20210114161442
#
# Table name: incoming_messages
#
#  id                             :integer          not null, primary key
#  info_request_id                :integer          not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  raw_email_id                   :integer          not null
#  cached_attachment_text_clipped :text
#  cached_main_body_text_folded   :text
#  cached_main_body_text_unfolded :text
#  subject                        :text
#  mail_from_domain               :text
#  valid_to_reply_to              :boolean
#  last_parsed                    :datetime
#  mail_from                      :text
#  sent_at                        :datetime
#  prominence                     :string           default("normal"), not null
#  prominence_reason              :text
#

FactoryBot.define do

  factory :incoming_message do
    info_request
    association :raw_email, strategy: :create
    last_parsed { 1.week.ago }
    sent_at { 1.week.ago }

    after(:build) do |incoming_message, evaluator|
      incoming_message.foi_attachments << build(
        :body_text,
        incoming_message: incoming_message,
        url_part_number: 1
      )

      incoming_message.raw_email.incoming_message = incoming_message
      incoming_message.raw_email.data = "somedata"
    end

    trait :unparsed do
      last_parsed { nil }
      sent_at { nil }
    end

    trait :hidden do
      prominence { 'hidden' }
    end

    factory :plain_incoming_message do
      last_parsed { nil }
      sent_at { nil }

      after(:create) do |incoming_message, evaluator|
        data = load_file_fixture('incoming-request-plain.email')
        data.gsub!('EMAIL_FROM', 'Bob Responder <bob@example.com>')
        incoming_message.raw_email.data = data
        incoming_message.raw_email.save!
      end
    end

    factory :incoming_message_with_html_attachment do
      after(:build) do |incoming_message, evaluator|
        incoming_message.foi_attachments << build(
          :html_attachment,
          incoming_message: incoming_message,
          url_part_number: 2
        )
      end
    end

    factory :incoming_message_with_attachments do
      # foi_attachments_count is declared as an ignored attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        foi_attachments_count { 2 }
      end

      # the after(:build) yields two values; the incoming_message instance itself and the
      # evaluator, which stores all values from the factory, including ignored
      # attributes;
      after(:build) do |incoming_message, evaluator|
        evaluator.foi_attachments_count.times do |count|
          incoming_message.foi_attachments << build(
            :pdf_attachment,
            incoming_message: incoming_message,
            url_part_number: count + 2
          )
        end
      end
    end
  end
end
