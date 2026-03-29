require "test_helper"

class VenuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @venue = venues(:one)
  end

  test "should get index" do
    get venues_path
    assert_response :success
  end

  test "should get new" do
    sign_in_as(users(:one))
    get new_venue_path
    assert_response :success
  end

  test "should create venue" do
    sign_in_as(users(:one))
    assert_difference("Venue.count") do
      post venues_path, params: { venue: { name: "Aberdare", code_name: "aberdare" } }
    end

    assert_redirected_to venues_path
  end

  test "should get edit" do
    sign_in_as(users(:one))
    get edit_venue_path(@venue)
    assert_response :success
  end

  test "should update venue" do
    sign_in_as(users(:one))
    patch venue_path(@venue), params: { venue: { name: @venue.name + "A" } }
    assert_redirected_to venues_path
  end

  test "should destroy venue" do
    sign_in_as(users(:one))
    assert_difference("Venue.count", -1) do
      delete venue_path(@venue)
    end

    assert_redirected_to venues_path
  end
end
