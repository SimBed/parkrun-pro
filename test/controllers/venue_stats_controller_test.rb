require "test_helper"

class VenueStatsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get venue_stats_path
    assert_response :success
  end
end
