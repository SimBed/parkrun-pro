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
    # @agegroup_columns = { junior: Run.agegroup_like("J"),
    #             men: Run.agegroup_like("SM") + Run.agegroup_like("VM"),
    #             women: Run.agegroup_like("SW") + Run.agegroup_like("VW"),
    #             wheelchair: Run.agegroup_like("WC")
    #           }
  end

  def prepare_dates
    # @dates = Run.dates.map { |date| date.strftime("%d %B %Y") }
    @dates = Run.dates
  end
end
