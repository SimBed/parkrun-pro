class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Method
  include SessionsHelper
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def prepare_agegroups
    @agegroup_columns = Agegroup.categorized
  end

  def prepare_dates
    @dates = Run.dates
  end

  def normalize_runs_filters!(filters)
    return unless filters.key?(:runs)

    runs = filters[:runs]

    # Ensure keys exist even if not submitted. Otherwise when a final agegroup is unchecked, the key is missing from the params and so is not updated in the session, meaning the filter is not cleared as required.
    runs[:any_agegroup_of] = nil unless runs.key?(:any_agegroup_of)
  end
end
