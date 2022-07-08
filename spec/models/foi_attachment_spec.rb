# == Schema Information
# Schema version: 20210114161442
#
# Table name: foi_attachments
#
#  id                    :integer          not null, primary key
#  content_type          :text
#  filename              :text
#  charset               :text
#  display_size          :text
#  url_part_number       :integer
#  within_rfc822_subject :text
#  incoming_message_id   :integer
#  hexdigest             :string(32)
#  created_at            :datetime
#  updated_at            :datetime
#

require 'spec_helper'

RSpec.describe FoiAttachment do
  describe '.binary' do
    subject { described_class.binary }

    before do
      FactoryBot.create(:body_text)
      FactoryBot.create(:html_attachment)
    end

    let(:binary_attachments) do
      [FactoryBot.create(:pdf_attachment),
       FactoryBot.create(:rtf_attachment),
       FactoryBot.create(:jpeg_attachment),
       FactoryBot.create(:unknown_attachment)]
    end

    it { is_expected.to match_array(binary_attachments) }
  end

  describe '#body=' do

    it "sets the body" do
      attachment = FoiAttachment.new
      attachment.body = "baz"
      expect(attachment.body).to eq("baz")
    end

    it "sets the size" do
      attachment = FoiAttachment.new
      attachment.body = "baz"
      expect(attachment.body).to eq("baz")
      expect(attachment.display_size).to eq("0K")
    end

    it "reparses the body if it disappears" do
      load_raw_emails_data
      im = incoming_messages(:useless_incoming_message)
      im.extract_attachments!
      main = im.get_main_body_text_part
      orig_body = main.body
      main.delete_cached_file!
      expect {
        im.get_main_body_text_part.body
      }.not_to raise_error
      main.delete_cached_file!
      main = im.get_main_body_text_part
      expect(main.body).to eq(orig_body)
    end

  end

  describe '#body' do

    it 'returns a binary encoded string when newly created' do
      foi_attachment = FactoryBot.create(:body_text)
      expect(foi_attachment.body.encoding.to_s).to eq('ASCII-8BIT')
    end


    it 'returns a binary encoded string when saved' do
      foi_attachment = FactoryBot.create(:body_text)
      foi_attachment = FoiAttachment.find(foi_attachment.id)
      expect(foi_attachment.body.encoding.to_s).to eq('ASCII-8BIT')
    end

  end

  describe '#body_as_text' do

    it 'has a valid UTF-8 string when newly created' do
      foi_attachment = FactoryBot.create(:body_text)
      expect(foi_attachment.body_as_text.string.encoding.to_s).to eq('UTF-8')
      expect(foi_attachment.body_as_text.string.valid_encoding?).to be true
    end

    it 'has a valid UTF-8 string when saved' do
      foi_attachment = FactoryBot.create(:body_text)
      foi_attachment = FoiAttachment.find(foi_attachment.id)
      expect(foi_attachment.body_as_text.string.encoding.to_s).to eq('UTF-8')
      expect(foi_attachment.body_as_text.string.valid_encoding?).to be true
    end


    it 'has a true scrubbed? value if the body has been coerced to valid UTF-8' do
      foi_attachment = FactoryBot.create(:body_text)
      foi_attachment.body = "\x0FX\x1C\x8F\xA4\xCF\xF6\x8C\x9D\xA7\x06\xD9\xF7\x90lo"
      expect(foi_attachment.body_as_text.scrubbed?).to be true
    end

    it 'has a false scrubbed? value if the body has not been coerced to valid UTF-8' do
      foi_attachment = FactoryBot.create(:body_text)
      foi_attachment.body = "κόσμε"
      expect(foi_attachment.body_as_text.scrubbed?).to be false
    end

  end

  describe '#default_body' do

    it 'returns valid UTF-8 for a text attachment' do
      foi_attachment = FactoryBot.create(:body_text)
      expect(foi_attachment.default_body.encoding.to_s).to eq('UTF-8')
      expect(foi_attachment.default_body.valid_encoding?).to be true
    end

    it 'returns binary for a PDF attachment' do
      foi_attachment = FactoryBot.create(:pdf_attachment)
      expect(foi_attachment.default_body.encoding.to_s).to eq('ASCII-8BIT')
    end

  end

  describe '#filename=' do
    it 'strips null bytes' do
      attachment = FactoryBot.build(:pdf_attachment)
      attachment.filename = "Tender Loving Care Trust (Europe).pdf\u0000"
      expect(attachment.filename).to eq('Tender Loving Care Trust (Europe).pdf')
    end
  end

  describe '#ensure_filename!' do

    it 'should create a filename for an instance with a blank filename' do
      attachment = FoiAttachment.new
      attachment.filename = ''
      attachment.ensure_filename!
      expect(attachment.filename).to eq('attachment.bin')
    end

  end

  describe '#has_body_as_html?' do

    it 'should be true for a pdf attachment' do
      expect(FactoryBot.build(:pdf_attachment).has_body_as_html?).to be true
    end

    it 'should be false for an html attachment' do
      expect(FactoryBot.build(:html_attachment).has_body_as_html?).to be false
    end

  end

end
