# override behaviour in fast_gettext/translation.rb
# so that we can interpolate our translation strings nicely

# TODO: We could simplify a lot of this code (as in remove it) if we moved from using the {{value}}
# convention in the translation strings for interpolation to %{value}. This is apparently the newer
# convention.

def _(key, options = {})
  translation = (FastGettext._(key) || key).html_safe
  gettext_interpolate(translation, options)
end

def n_(*keys)
  # The last parameter could be the values to do the interpolation with
  options = keys.extract_options!

  # The last key needs to be the pluralisation count and should be a integer
  count = keys.pop.to_i

  translation = FastGettext.n_(*keys, count).html_safe
  gettext_interpolate(translation, options)
end

MATCH = /\{\{([^\}]+)\}\}/

def gettext_interpolate(string, values)
  return string unless string.is_a?(String)
  # $1, $2 don't work with SafeBuffer so casting to string as workaround
  safe = string.html_safe?
  string = string.to_str.gsub(MATCH) do
    pattern, key = $1, $1.to_sym

    if !values.include?(key)
      raise I18n::MissingInterpolationArgument.new(pattern, string, values)
    else
      v = values[key].to_s
      if safe && !v.html_safe?
        ERB::Util.h(v)
      else
        v
      end
    end
  end
  safe ? string.html_safe : string
end


# this monkeypatch corrects inconsistency with gettext_i18n_rails
# where the latter deals with strings but rails i18n deals with
# symbols for locales
module GettextI18nRails
  class Backend
    def available_locales
      FastGettext.available_locales.map { |l| l.to_sym } || []
    end
  end
end

# Monkeypatch Globalize to compensate for the way gettext_i18n_rails patches
# I18n.locale= so that it changes underscores in locale names (as used in the gettext world)
# to the dashes that I18n prefers
module Globalize
  class << self
    def locale
      read_locale || AlaveteliLocalization.locale
    end
  end
end
