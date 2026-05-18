require "test_helper"

class BestTimesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get best_times_path
    assert_response :success
  end
end
