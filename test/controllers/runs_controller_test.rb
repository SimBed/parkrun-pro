require "test_helper"

class RunsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    # TODO: test the 3 ways of calculating summary stats based on sessions
    SummaryStats.refresh # no data in materialized view if not refreshed
    get runs_path
    assert_response :success
  end
end
