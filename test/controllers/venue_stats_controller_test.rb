require "test_helper"

class VenueStatsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get venue_stats_path
    assert_response :success
  end
  test "should get index when age groups are specified" do
    get venue_stats_path, params: { filters: { runs: { any_agegroup_of: [ "M35-39", "F40-44" ] } } }
    assert_response :success
  end
end
