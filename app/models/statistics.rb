# Collection of classes and methods to generate various statistics
# Many of the top-level methods ought to be extracted to classes.
module Statistics
  def self.public_bodies
    per_graph = 10
    minimum_requests = AlaveteliConfiguration.minimum_requests_for_statistics
    # Make sure minimum_requests is > 0 to avoid division-by-zero
    minimum_requests = [minimum_requests, 1].max
    total_column = 'info_requests_count'

    graph_list = []

    [
      [total_column,
       [{ title: _('Public bodies with the most requests'),
          y_axis: _('Number of requests'),
          highest: true }]],
      ['info_requests_successful_count',
       [{ title: _('Public bodies with the most successful requests'),
          y_axis: _('Percentage of total requests'),
          highest: true },
        { title: _('Public bodies with the fewest successful requests'),
          y_axis: _('Percentage of total requests'),
          highest: false }]],
      ['info_requests_overdue_count',
       [{ title: _('Public bodies with most overdue requests'),
          y_axis: _('Percentage of requests that are overdue'),
          highest: true }]],
      ['info_requests_not_held_count',
       [{ title: _('Public bodies that most frequently replied with ' \
                   '"Not Held"'),
          y_axis: _('Percentage of total requests'),
          highest: true }]]
    ].each do |column, graphs_properties|
      graphs_properties.each do |graph_properties|
        percentages = (column != total_column)
        highest = graph_properties[:highest]

        data = nil
        data =
          if percentages
            PublicBody.get_request_percentages(column,
                                               per_graph,
                                               highest,
                                               minimum_requests)
          else
            PublicBody.get_request_totals(per_graph,
                                          highest,
                                          minimum_requests)
          end

        if data
          graph_list.push simplify_stats_for_graphs(data,
                                                    column,
                                                    percentages,
                                                    graph_properties)
        end
      end
    end

    graph_list
  end

  # This is a helper method to take data returned by the above method and
  # converting them to simpler data structure that can be rendered by a
  # Javascript graph library.
  def self.simplify_stats_for_graphs(data, column, percentages, graph_properties)
    # Copy the data, only taking known-to-be-safe keys:
    result = Hash.new { |h, k| h[k] = [] }

    result.update Hash[data.select do |key, _value|
      %w[y_values
         y_max
         totals
         cis_below
         cis_above].include?(key)
    end]

    # Extract data about the public bodies for the x-axis,
    # tooltips, and so on:
    data['public_bodies'].each_with_index do |pb, i|
      result['x_values'] << i
      result['x_ticks'] << [i, pb.short_or_long_name.truncate(30)]
      result['tooltips'] << "#{pb.name} (#{result['totals'][i]})"
      result['public_bodies'] << {
        'name' => pb.name,
        # FIXME: This seems nasty, can we simplify it?
        'url' => Rails.application.routes.url_helpers.
                  show_public_body_path(url_name: pb.url_name)
      }
    end

    # Set graph metadata properties, like the title, axis labels, etc.
    graph_id = "#{column}-"
    graph_id += graph_properties[:highest] ? 'highest' : 'lowest'
    result.update({ 'id' => graph_id,
                    'x_axis' => _('Public Bodies'),
                    'y_axis' => graph_properties[:y_axis],
                    'errorbars' => percentages,
                    'title' => graph_properties[:title] })
  end

  def self.leaderboard
    leaderboard = Leaderboard.new
    { all_time_requesters: leaderboard.all_time_requesters,
      last_28_day_requesters: leaderboard.last_28_day_requesters,
      all_time_commenters: leaderboard.all_time_commenters,
      last_28_day_commenters: leaderboard.last_28_day_commenters }
  end

  def self.user_json_for_api(user_statistics)
    user_statistics.each do |k, v|
      user_statistics[k] = v.map { |u, c| { user: u.json_for_api, count: c } }
    end
  end

  def self.by_week_to_today_with_noughts(counts_by_week, start_date)
    earliest_week = start_date.to_date.at_beginning_of_week
    latest_week = Date.current.at_beginning_of_week

    counts_by_week.map! { |date, count| [date.to_s, count] }

    (earliest_week..latest_week).step(7) do |date|
      unless counts_by_week.any? { |c| c.first == date.to_s }
        counts_by_week << [date.to_s, 0]
      end
    end

    counts_by_week.sort
  end
end
