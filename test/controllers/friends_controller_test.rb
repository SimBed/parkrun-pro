require "test_helper"

class FriendsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get friends_path
    assert_response :success
  end

  test "filters records by names" do
  get friends_path, params: { names: [ "Pete" ] },
                    headers: { "Accept" => "text/vnd.turbo-stream.html" }

  assert_response :success
  assert_select "td", text: "Pete STOCKY"
end
end
