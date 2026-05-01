require "test_helper"

class RunsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    travel_to Time.zone.local(2026, 3, 14)
    # TODO: test the 3 ways of calculating summary stats based on sessions
    SummaryStats.refresh # no data in materialized view if not refreshed
    get runs_path
    assert_response :success
  end
end
