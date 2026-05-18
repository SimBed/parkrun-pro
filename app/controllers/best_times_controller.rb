class BestTimesController < ApplicationController
  allow_unauthenticated_access
  def index
    extract_filters
    prepare_filter_options
    set_filters
    handle_filters
    handle_sort
  end

  def clear_filters
    session["filters"]["best_times"]["any_agegroup_of"] = nil
    redirect_to best_times_path
  end

  private

    def extract_filters
      if params[:filters]
      new_filters = filter_params.to_h

      normalize_best_times_filters!(new_filters)

      session[:filters] ||= {}
      session[:filters].deep_merge!(new_filters)
      end

      @filters = (session[:filters] || {}).with_indifferent_access
    end

    def normalize_best_times_filters!(filters)
      return unless filters.key?(:best_times)

      best_times = filters[:best_times]

      # Ensure :any_agegroup_of key exists even if not submitted. Otherwise when a final agegroup is unchecked, the key is missing from the params and so is not updated in the session, meaning the filter is not cleared as required.
      best_times[:any_agegroup_of] = nil unless best_times.key?(:any_agegroup_of)
    end

    def set_filters
      @venue = @filters.dig(:best_times, :venue) || "All"
    end

    def prepare_filter_options
        prepare_agegroups
        prepare_venues
    end

    def prepare_venues
      @venues = [ [ "All Venues", "All" ] ] + Run.venues
    end

    def handle_filters
      @runs = @venue == "All" ? Run.all : Run.where(venue: @venue)
      @runs = RunQuery.new(@filters, @runs, :best_times).call
    end

    def handle_sort
      @runs = @runs.order(time: :asc).limit(100)
    end

    def filter_params
      params.require(:filters).permit(
        best_times: [
          :venue,
          { any_agegroup_of: [] }
        ]
      )
    end
end
