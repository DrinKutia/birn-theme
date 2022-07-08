require 'spec_helper'

RSpec.describe UserSpamScorer do

  after(:each) { described_class.reset }

  describe '.currency_symbols' do

    it 'sets a default currency_symbols value' do
      expect(described_class.currency_symbols).
        to eq(described_class::DEFAULT_CURRENCY_SYMBOLS)
    end

    it 'sets a custom currency_symbols value' do
      described_class.currency_symbols = %w(£ $)
      expect(described_class.currency_symbols).to eq(%w(£ $))
    end

  end

  describe '.score_mappings' do

    it 'sets a default score_mappings value' do
      expect(described_class.score_mappings).
        to eq(described_class::DEFAULT_SCORE_MAPPINGS)
    end

    it 'sets a custom score_mappings value' do
      described_class.score_mappings = { :name_is_one_word? => 7 }
      expect(described_class.score_mappings).to eq({ :name_is_one_word? => 7 })
    end

  end

  describe '.suspicious_domains' do

    it 'sets a default suspicious_domains value' do
      expect(described_class.suspicious_domains).
        to eq(described_class::DEFAULT_SUSPICIOUS_DOMAINS)
    end

    it 'sets a custom suspicious_domains value' do
      described_class.suspicious_domains = %w(example.com)
      expect(described_class.suspicious_domains).to eq(%w(example.com))
    end

  end

  describe '.spam_domains' do

    it 'sets a default spam_domains value' do
      expect(described_class.spam_domains).
        to eq(described_class::DEFAULT_SPAM_DOMAINS )
    end

    it 'sets a custom spam_domains value' do
      described_class.spam_domains = %w(example.com)
      expect(described_class.spam_domains).to eq(%w(example.com))
    end

  end

  describe '.spam_name_formats' do

    it 'sets a default spam_name_formats value' do
      expect(described_class.spam_name_formats).
        to eq(described_class::DEFAULT_SPAM_NAME_FORMATS)
    end

    it 'sets a custom spam_name_formats value' do
      described_class.spam_name_formats = [/\A.*$/]
      expect(described_class.spam_name_formats).to eq([/\A.*$/])
    end

  end

  describe '.spam_about_me_formats' do

    it 'sets a default spam_about_me_formats value' do
      expect(described_class.spam_about_me_formats).
        to eq(described_class::DEFAULT_SPAM_ABOUT_ME_FORMATS)
    end

    it 'sets a custom spam_about_me_formats value' do
      described_class.spam_about_me_formats = [/\A.*$/]
      expect(described_class.spam_about_me_formats).to eq([/\A.*$/])
    end

  end

  describe '.spam_score_threshold' do

    it 'sets a default spam_score_threshold value' do
      expect(described_class.spam_score_threshold).
        to eq(described_class::DEFAULT_SPAM_SCORE_THRESHOLD)
    end

    it 'sets a custom spam_score_threshold value' do
      described_class.spam_score_threshold = 1
      expect(described_class.spam_score_threshold).to eq(1)
    end

  end

  describe '.spam_tlds' do

    it 'sets a default spam_tlds value' do
      expect(described_class.spam_tlds).
        to eq(described_class::DEFAULT_SPAM_TLDS)
    end

    it 'sets a custom spam_tlds value' do
      described_class.spam_tlds = %w(ru)
      expect(described_class.spam_tlds).to eq(%w(ru))
    end

  end

  describe '.reset' do

    it 'resets the class instance variables' do
      attrs = described_class::CLASS_ATTRIBUTES

      defaults = attrs.reduce({}) do |memo, key|
        memo[key] = described_class.const_get("DEFAULT_#{ key }".upcase)
        memo
      end

      described_class.suspicious_domains = %w(example.net)
      described_class.reset

      current = attrs.reduce({}) do |memo, key|
        memo[key] = described_class.send(key)
        memo
      end

      expect(current).to eq(defaults)
    end

    it 'returns the list of attributes that were reset' do
      expect(described_class.reset).to eq(described_class::CLASS_ATTRIBUTES)
    end

  end

  describe '.new' do

    it 'sets a default currency_symbols value' do
      expect(subject.currency_symbols).to eq(described_class.currency_symbols)
    end

    it 'sets a custom currency_symbols value' do
      scorer = described_class.new(:currency_symbols => %w(£ $))
      expect(scorer.currency_symbols).to eq(%w(£ $))
    end

    it 'sets a default score_mappings value' do
      expect(subject.score_mappings).to eq(described_class.score_mappings)
    end

    it 'sets a custom score_mappings value' do
      scorer = described_class.new(:score_mappings => { :check => 1 })
      expect(scorer.score_mappings).to eq({ :check => 1 })
    end

    it 'sets a default suspicious_domains value' do
      expect(subject.suspicious_domains).
        to eq(described_class.suspicious_domains)
    end

    it 'sets a custom suspicious_domains value' do
      scorer = described_class.new(:suspicious_domains => %w(example.com))
      expect(scorer.suspicious_domains).to eq(%w(example.com))
    end

    it 'sets a default spam_name_formats value' do
      expect(subject.spam_name_formats).
        to eq(described_class.spam_name_formats)
    end

    it 'sets a custom spam_name_formats value' do
      scorer = described_class.new(:spam_name_formats => [/spam/])
      expect(scorer.spam_name_formats).to eq([/spam/])
    end

    it 'sets a default spam_about_me_formats value' do
      expect(subject.spam_about_me_formats).
        to eq(described_class.spam_about_me_formats)
    end

    it 'sets a custom spam_about_me_formats value' do
      scorer = described_class.new(:spam_about_me_formats => [/spam/])
      expect(scorer.spam_about_me_formats).to eq([/spam/])
    end

    it 'sets a default spam_score_threshold value' do
      expect(subject.spam_score_threshold).
        to eq(described_class.spam_score_threshold)
    end

    it 'sets a custom spam_score_threshold value' do
      scorer = described_class.new(:spam_score_threshold => 1)
      expect(scorer.spam_score_threshold).to eq(1)
    end

    it 'sets a default spam_tlds value' do
      expect(subject.spam_tlds).to eq(described_class.spam_tlds)
    end

    it 'sets a custom spam_tlds value' do
      scorer = described_class.new(:spam_tlds => %w(com))
      expect(scorer.spam_tlds).to eq(%w(com))
    end

  end

  describe '#spam?' do

    it 'returns true if the user spam score is above the threshold' do
      user_attrs = { :name => 'spammer', :comments => [], :track_things => [] }
      user = mock_model(User, user_attrs)
      attrs = { :score_mappings => { :name_is_one_word? => 100 },
                :spam_score_threshold => 5 }
      scorer = described_class.new(attrs)
      expect(scorer.spam?(user)).to eq(true)
    end

    it 'returns false if the user spam score is equal to the threshold' do
      user_attrs = { :name => 'genuine', :comments => [], :track_things => [] }
      user = mock_model(User, user_attrs)
      attrs = { :score_mappings => { :name_is_one_word? => 5 },
                :spam_score_threshold => 5 }
      scorer = described_class.new(attrs)
      expect(scorer.spam?(user)).to eq(false)
    end

    it 'returns false if the user spam score is below the threshold' do
      user_attrs = { :name => 'genuine', :comments => [], :track_things => [] }
      user = mock_model(User, user_attrs)
      attrs = { :score_mappings => { :name_is_one_word? => 5 },
                :spam_score_threshold => 100 }
      scorer = described_class.new(attrs)
      expect(scorer.spam?(user)).to eq(false)
    end

  end

  describe '#score' do

    it 'returns 0 if no mappings return true' do
      user_attrs = { :name => 'Bob Smith',
                     :comments => [],
                     :track_things => [] }
      user = mock_model(User, user_attrs)
      scorer = described_class.new(:score_mappings => {})
      expect(scorer.score(user)).to eq(0)
    end

    it 'returns 0 if the user has comments' do
      user_attrs = { :name => 'dubious',
                     :comments => [double],
                     :track_things => [] }
      user = mock_model(User, user_attrs)
      expect(subject.score(user)).to eq(0)
    end

    it 'returns 0 if the user has track_things' do
      user_attrs = { :name => 'dubious',
                     :comments => [],
                     :track_things => [double] }
      user = mock_model(User, user_attrs)
      expect(subject.score(user)).to eq(0)
    end

    it 'increases the score for each score mapping that returns true' do
      user_attrs = { :name => 'Spammer',
                     :email_domain => 'mail.ru',
                     :comments => [],
                     :track_things => [] }
      user = mock_model(User, user_attrs)
      opts = { :score_mappings => { :name_is_all_lowercase? => 1,
                                    :name_is_one_word? => 2,
                                    :email_from_suspicious_domain? => 3 } }
      scorer = described_class.new(opts)
      expect(scorer.score(user)).to eq(5)
    end

    it 'raises an error if a mapping is invalid' do
      user_attrs = { :name => 'Bob Smith',
                     :comments => [],
                     :track_things => [] }
      user = mock_model(User, user_attrs)
      scorer = described_class.new(:score_mappings => { :invalid_method => 1 })
      expect { scorer.score(user) }.to raise_error(NoMethodError)
    end

  end

  describe '#name_is_all_lowercase?' do

    it 'is true if the name is all lowercase' do
      user = mock_model(User, :name => 'bob smith 123')
      expect(subject.name_is_all_lowercase?(user)).to eq(true)
    end

    it 'is false if the name is not all lowercase' do
      user = mock_model(User, :name => 'Bob smith 123')
      expect(subject.name_is_all_lowercase?(user)).to eq(false)
    end

  end

  describe '#name_is_one_word?' do

    it 'is true if the name is one word' do
      user = mock_model(User, :name => 'bobsmith123')
      expect(subject.name_is_one_word?(user)).to eq(true)
    end

    it 'is false if the name includes a space' do
      user = mock_model(User, :name => 'bob smith 123')
      expect(subject.name_is_one_word?(user)).to eq(false)
    end

  end

  describe '#name_is_garbled?' do

    it 'is true if the name includes 5 consecutive consonants' do
      user = mock_model(User, :name => 'JWahewKjWhebCd')
      expect(subject.name_is_garbled?(user)).to eq(true)
    end

    it 'is false if the name does not include 5 consecutive consonants' do
      user = mock_model(User, :name => 'Bob Smith')
      expect(subject.name_is_garbled?(user)).to eq(false)
    end

  end

  describe '#name_includes_non_alpha_characters?' do

    it 'is true if the name includes numbers' do
      user = mock_model(User, :name => 'Bob smith 123')
      expect(subject.name_includes_non_alpha_characters?(user)).to eq(true)
    end

    it 'is true if the name includes non-word characters' do
      user = mock_model(User, :name => 'Bob!!!')
      expect(subject.name_includes_non_alpha_characters?(user)).to eq(true)
    end

    it 'is false if the name is English alpha characters' do
      user = mock_model(User, :name => 'Bob')
      expect(subject.name_includes_non_alpha_characters?(user)).to eq(false)
    end

    it 'is false if the name is English alpha characters and whitespace' do
      user = mock_model(User, :name => 'Bob smith')
      expect(subject.name_includes_non_alpha_characters?(user)).to eq(false)
    end

  end

  describe '#email_from_suspicious_domain?' do

    it 'is true if the email is from a suspicious domain' do
      mock_suspicious_domains = %w(example.com example.net example.org)
      user = mock_model(User, :email_domain => 'example.net')
      scorer = described_class.new(
                 :suspicious_domains => mock_suspicious_domains)
      expect(scorer.email_from_suspicious_domain?(user)).to eq(true)
    end

    it 'is false if the email is not from a suspicious domain' do
      mock_suspicious_domains = %w(example.com example.org)
      user = mock_model(User, :email_domain => 'example.net')
      scorer = described_class.new(
                 :suspicious_domains => mock_suspicious_domains)
      expect(scorer.email_from_suspicious_domain?(user)).to eq(false)
    end

  end

  describe '#email_from_spam_domain?' do

    it 'is true if the email is from a spam domain' do
      mock_spam_domains = %w(example.com example.net example.org)
      user = mock_model(User, :email_domain => 'example.net')
      scorer = described_class.new(:spam_domains => mock_spam_domains)
      expect(scorer.email_from_spam_domain?(user)).to eq(true)
    end

    it 'is false if the email is not from a spam domain' do
      mock_spam_domains = %w(example.com example.org)
      user = mock_model(User, :email_domain => 'example.net')
      scorer = described_class.new(:spam_domains => mock_spam_domains)
      expect(scorer.email_from_spam_domain?(user)).to eq(false)
    end

  end

  describe '#email_from_spam_tld?' do

    it 'is true if the email is from a spam tld' do
      mock_spam_tlds = %w(com net org)
      user = mock_model(User, :email_domain => 'example.net')
      scorer = described_class.new(:spam_tlds => mock_spam_tlds)
      expect(scorer.email_from_spam_tld?(user)).to eq(true)
    end

    it 'is false if the email is not from a spam tld' do
      mock_spam_tlds = %w(com org)
      user = mock_model(User, :email_domain => 'example.net')
      scorer = described_class.new(:spam_tlds => mock_spam_tlds)
      expect(scorer.email_from_spam_tld?(user)).to eq(false)
    end

  end

  describe '#name_is_spam_format?' do

    it 'is true if the name matches a spammy format' do
      mock_spam_formats = [/\A.*support.*\z/]
      user = mock_model(User, name: 'support')
      scorer = described_class.new(spam_name_formats: mock_spam_formats)
      expect(scorer.name_is_spam_format?(user)).to eq(true)
    end

    it 'is false if the name is not a spammy format' do
      mock_spam_formats = [/\A.*support.*\z/]
      user = mock_model(User, name: 'Bob Smith')
      scorer = described_class.new(spam_name_formats: mock_spam_formats)
      expect(scorer.name_is_spam_format?(user)).to eq(false)
    end

    context 'the default spam formats' do

      it 'is true if it matches bitcoin' do
        user = mock_model(User, name: 'bitcointocash')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches currency' do
        user = mock_model(User, name: 'Currency Transfers')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches support' do
        user = mock_model(User, name: 'Apple Technical Support')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches customer service' do
        user = mock_model(User, name: 'Apple Customer Service Number')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches customer care' do
        user = mock_model(User, name: 'Dell Customer Care')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches buy online' do
        user = mock_model(User, name: 'Buy Spam Online')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches real estate' do
        user = mock_model(User, name: 'Buy Real Estate')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches web design' do
        user = mock_model(User, name: 'Web Design')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches mac desktop' do
        user = mock_model(User, name: 'Mac Desktop')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches Inc' do
        user = mock_model(User, name: 'Spam Co, Inc')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches LLC' do
        user = mock_model(User, name: 'Spam Co, LLC')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches spyware' do
        user = mock_model(User, name: 'spywareremoval')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches malware' do
        user = mock_model(User, name: 'malwareremoval')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches CRM' do
        user = mock_model(User, name: 'Unify CRM')
        expect(subject.name_is_spam_format?(user)).to eq(true)
      end

    end

  end

  describe '#about_me_includes_currency_symbol?' do

    it 'is true if the about me includes a currency symbol' do
      mock_currency_symbols = %w(£ $)
      user = mock_model(User, :about_me => 'Spam for just $100')
      scorer = described_class.new(:currency_symbols => mock_currency_symbols)
      expect(scorer.about_me_includes_currency_symbol?(user)).to eq(true)
    end

    it 'is false if the about me does not include a currency symbol' do
      mock_currency_symbols = %w(£ $)
      user = mock_model(User, :about_me => 'No spam here')
      scorer = described_class.new(:currency_symbols => mock_currency_symbols)
      expect(scorer.about_me_includes_currency_symbol?(user)).to eq(false)
    end

  end

  describe '#about_me_is_link_only?' do

    it 'is true if the about me is just a HTTP URL' do
      user = mock_model(User, :about_me => 'http://example.com')
      expect(subject.about_me_is_link_only?(user)).to eq(true)
    end

    it 'is true if the about me is just a HTTPS URL' do
      user = mock_model(User, :about_me => 'https://example.com')
      expect(subject.about_me_is_link_only?(user)).to eq(true)
    end

    it 'is false if the about me has text only' do
      user = mock_model(User, :about_me => 'No spam here')
      expect(subject.about_me_is_link_only?(user)).to eq(false)
    end

    it 'is false if the about me includes other text' do
      user = mock_model(User, :about_me => "No spam at\n\nhttp://example.com")
      expect(subject.about_me_is_link_only?(user)).to eq(false)
    end

    it 'is false if the about me includes other text' do
      user = mock_model(User, :about_me => 'http://example.com no spam there')
      expect(subject.about_me_is_link_only?(user)).to eq(false)
    end

    it 'is case insensitive' do
      user = mock_model(User, :about_me => 'HTTP://EXAMPLE.COM')
      expect(subject.about_me_is_link_only?(user)).to eq(true)
    end

  end

  describe '#about_me_is_spam_format?' do

    it 'is true if the about me matches a spammy format' do
      mock_spam_formats = [/\A.*+\n{2,}https?:\/\/[^\s]+\z/]
      user = mock_model(User, :about_me => <<-EOF.strip_heredoc)
      Some spam often looks like this spam

      http://www.example.org/
      EOF
      scorer = described_class.new(:spam_about_me_formats => mock_spam_formats)
      expect(scorer.about_me_is_spam_format?(user)).to eq(true)
    end

    it 'is false if the about me is not a spammy format' do
      mock_spam_formats = [/\A.*+\n{2,}https?:\/\/[^\s]+\z/]
      user = mock_model(User, :about_me => 'No spam here')
      scorer = described_class.new(:spam_about_me_formats => mock_spam_formats)
      expect(scorer.about_me_is_spam_format?(user)).to eq(false)
    end

    it 'replaces \r\n with \n' do
      mock_spam_formats = [/\Aspam\nspam\z/]
      user = mock_model(User, :about_me => <<-EOF.strip_heredoc)
      spam\r\nspam
      EOF
      scorer = described_class.new(:spam_about_me_formats => mock_spam_formats)
      expect(scorer.about_me_is_spam_format?(user)).to eq(true)
    end

    context 'the default spam formats' do

      it 'is true if it matches TEXT\n\nURL' do
        user = mock_model(User, :about_me => <<-EOF.strip_heredoc)
        Some spam often looks like this spam

        http://www.example.org/
        EOF
        expect(subject.about_me_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches URL\n\nTEXT' do
        user = mock_model(User, :about_me => <<-EOF.strip_heredoc)
        http://www.example.org/

        Some spam often looks like this spam
        EOF
        expect(subject.about_me_is_spam_format?(user)).to eq(true)
      end

      it 'is true if it matches TEXT\n\nTEXT\n\nURL' do
        user = mock_model(User, :about_me => <<-EOF.strip_heredoc)
        Some spam often looks like this spam

        It even has some more spam

        http://www.example.org/
        EOF
        expect(subject.about_me_is_spam_format?(user)).to eq(true)
      end

    end

  end

  describe '#about_me_includes_anchor_tag?' do

    it 'is true if the about me includes an a tag' do
      user = mock_model(User, :about_me => 'Spam link <a href="">here</a>')
      expect(subject.about_me_includes_anchor_tag?(user)).to eq(true)
    end

    it 'is false if the about me does not include an a tag' do
      user = mock_model(User, :about_me => 'No spam here')
      expect(subject.about_me_includes_anchor_tag?(user)).to eq(false)
    end
  end

  describe '#about_me_already_exists?' do

    it 'is true if the about me already exists' do
      user = mock_model(User, :about_me_already_exists? => true)
      expect(subject.about_me_already_exists?(user)).to eq(true)
    end

    it 'is false if the about me is unique to the user' do
      user = mock_model(User, :about_me_already_exists? => false)
      expect(subject.about_me_already_exists?(user)).to eq(false)
    end

  end

  describe '#user_agent_is_suspicious?' do

    before { UserSpamScorer.suspicious_user_agents = ['cURL'] }
    after { UserSpamScorer.reset }

    it 'is true if the user agent matches' do
      user = mock_model(User, :user_agent => 'cURL')
      expect(subject.user_agent_is_suspicious?(user)).to eq(true)
    end

    it 'is false if the user agent does not match' do
      user = mock_model(User, :user_agent => 'Firefox')
      expect(subject.user_agent_is_suspicious?(user)).to eq(false)
    end

    it 'is false if the user does not have a user agent' do
      user = mock_model(User)
      expect(subject.user_agent_is_suspicious?(user)).to eq(false)
    end

  end

  describe '#ip_range_is_suspicious?' do

    before { UserSpamScorer.suspicious_ip_ranges = [IPAddr.new('127.0.0.0/8')] }
    after { UserSpamScorer.reset }

    it 'is true if the IP address is within a suspicious range' do
      user = mock_model(User, :ip => '127.0.0.1')
      expect(subject.ip_range_is_suspicious?(user)).to eq(true)
    end

    it 'is false if the IP address is not within a suspicious range' do
      user = mock_model(User, :ip => '10.0.0.1')
      expect(subject.ip_range_is_suspicious?(user)).to eq(false)
    end

    it 'is false if the user does not have a IP address' do
      user = mock_model(User)
      expect(subject.ip_range_is_suspicious?(user)).to eq(false)
    end

  end

end
