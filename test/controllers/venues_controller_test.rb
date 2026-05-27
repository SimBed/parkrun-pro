require "test_helper"

class VenuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @venue = venues(:abbeypark)
  end

  test "should get index" do
    get venues_path
    assert_response :success
  end

  test "should get new" do
    sign_in_as(users(:user1))
    get new_venue_path
    assert_response :success
  end

  test "should create venue" do
    sign_in_as(users(:user1))
    assert_difference("Venue.count") do
      post venues_path, params: { venue: { name: "Aberdare", code_name: "aberdare" } }
    end

    assert_redirected_to venues_path
  end

  test "should get edit" do
    sign_in_as(users(:user1))
    get edit_venue_path(@venue)
    assert_response :success
  end

  test "should update venue" do
    sign_in_as(users(:user1))
    patch venue_path(@venue), params: { venue: { name: @venue.name + "A" } }
    assert_redirected_to venues_path
  end
end
