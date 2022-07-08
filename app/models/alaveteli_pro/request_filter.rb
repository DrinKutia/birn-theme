module AlaveteliPro
  class RequestFilter

    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :filter, :order, :search

    def update(attributes = {})
      self.attributes = attributes
    end

    def attributes=(attributes)
      self.filter = attributes[:filter] unless attributes[:filter].blank?
      self.order = attributes[:order]
      self.search = attributes[:search]
    end

    def order_options
      order_attributes.map { |atts| [atts[:capital_label], atts[:param]] }
    end

    def order_label
      order_params.include?(@order) ? order_labels[@order] : order_labels[default_order]
    end

    def filter_label
      filter_params.include?(@filter) ? filter_labels[@filter] : filter_labels[nil]
    end

    def filter_capital_label
      filter_params.include?(@filter) ? filter_capital_labels[@filter] : filter_capital_labels[nil]
    end

    def results(user)
      request_summaries = user.request_summaries
      request_summaries =
        request_summaries
          .includes(:request_summary_categories)
            .where("title ILIKE :q
                   OR body ILIKE :q
                   OR public_body_names ILIKE :q",
                   q: "%#{ search }%")
              .references(:request_summary_categories)
      request_summaries = filter_results(request_summaries)
      request_summaries.reorder("request_summaries.#{order_value}")
    end

    def filter_results(results)
      if filter_value.blank?
        results.not_category('draft')
      else
        results.category(filter_value)
      end
    end

    def persisted?
      false
    end

    def default_order
      'updated_at_desc'
    end

    private

    def order_attributes
      [
       { :param => 'updated_at_desc',
         :value => 'request_updated_at DESC',
         :label => _('last updated'),
         :capital_label => _('Last updated') },
       { :param => 'created_at_asc',
         :value => 'request_created_at ASC',
         :label => _('first created'),
         :capital_label => _('First created') },
       { :param => 'title_asc',
         :value => 'title ASC',
         :label => _('title (A-Z)'),
         :capital_label => _('Title (A-Z)') }
      ]
    end

    def order_params
      order_attributes.map { |atts| atts[:param] }
    end

    def order_values
      Hash[order_attributes.map { |atts| [ atts[:param], atts[:value] ] }]
    end

    def order_capital_labels
      Hash[ order_options ].invert
    end

    def order_labels
      Hash[ order_attributes.map { |atts| [atts[:param], atts[:label]] } ]
    end

    def order_value
      order_params.include?(@order) ? order_values[@order] : order_values[default_order]
    end

    def default_filters
      [
        { :param => nil,
          :value => nil,
          :label => _('all requests'),
          :capital_label => _('All requests') },
        { :param => 'draft',
          :value => :draft,
          :label => _('drafts'),
          :capital_label => _('Drafts') },
        { :param => 'embargoes_expiring',
          :value => :embargo_expiring,
          :label => _('requests that will be made public soon'),
          :capital_label => _('Requests that will be made public soon')
        }
      ]
    end

    def phase_filters
      InfoRequest::State.phases.map { |phase| { :param => phase[:scope].to_s,
                                               :value => phase[:scope],
                                               :label => phase[:label],
                                               :capital_label => phase[:capital_label] } }
    end

    def filter_attributes
      default_filters + phase_filters
    end

    def filter_options
      filter_attributes.map { |atts| [atts[:capital_label], atts[:param]] }
    end

    def filter_capital_labels
      Hash[ filter_options ].invert
    end

    def filter_params
      filter_attributes.map { |atts| atts[:param] }
    end

    def filter_values
      Hash[ filter_attributes.map { |atts| [ atts[:param], atts[:value] ] } ]
    end

    def filter_labels
      Hash[ filter_attributes.map { |atts| [atts[:param], atts[:label]] } ]
    end

    def filter_value
      filter_params.include?(@filter) ? filter_values[@filter] : filter_values[nil]
    end

  end
end
