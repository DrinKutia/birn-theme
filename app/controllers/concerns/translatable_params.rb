module TranslatableParams

  def translatable_params(params, **keys)
    return {} unless params
    WhitelistedParams.new(**keys).whitelist(params)
  end

  extend ActiveSupport::Concern

  # Class to whitelist the parameters hash for a model that accepts
  # translation data via "accepts_nested_attributes_for :translations"
  #
  # @param translated_keys [Array] a list of whitelisted keys for translation
  #   models
  # @param general_keys [Array] an optional list of whitelisted keys for the
  #   base model
  class WhitelistedParams
    include ::HashableParams

    attr_reader :translated_keys, :general_keys

    def initialize(translated_keys:, general_keys: [])
      @translated_keys = translated_keys
      @general_keys = general_keys
    end

    # Return a whitelisted params hash given the raw params
    # params - the param hash to be whitelisted
    def whitelist(raw_parameters)
      hashed_params = params_to_unsafe_hash(raw_parameters)
      sliced_params = hashed_params.slice(*model_keys)
      sliced_params = slice_translations_params(sliced_params)
      ActionController::Parameters.new(sliced_params).permit!
    end

    private

    def model_keys
      translated_keys + general_keys + [:translations_attributes]
    end

    def translation_keys
      translated_keys + [:id]
    end

    def slice_translations_params(sliced_params)
      if translation_params = sliced_params[:translations_attributes]
        translation_params.each do |locale, attributes|
          translation_params[locale] = attributes.slice(*translation_keys)
        end
      end
      sliced_params
    end

  end

end
