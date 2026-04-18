require "test_helper"

class FriendsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get friends_path
    assert_response :success
  end
end
