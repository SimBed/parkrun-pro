require "test_helper"

class RunsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get runs_path
    assert_response :success
  end
end
