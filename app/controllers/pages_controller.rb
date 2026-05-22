class PagesController < ApplicationController
  allow_unauthenticated_access
  def about
    @run_count = Run.count
    @venue_count = Venue.count
    @fastest_time = Run.minimum(:time)
  end
end
