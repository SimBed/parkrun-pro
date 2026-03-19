require "test_helper"

class ParkrunsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parkrun = parkruns(:one)
  end

  test "should get index" do
    get parkruns_path
    assert_response :success
  end

  test "should get new" do
    sign_in_as(users(:one))
    get new_parkrun_path
    assert_response :success
  end

  test "should create parkrun" do
    sign_in_as(users(:one))
    assert_difference("Parkrun.count") do
      post parkruns_path, params: { parkrun: { name: 'Aberdare', code_name: 'aberdare' } }
    end

    assert_redirected_to parkruns_path
  end

  test "should get edit" do
    sign_in_as(users(:one))
    get edit_parkrun_path(@parkrun)
    assert_response :success
  end

  test "should update parkrun" do
    sign_in_as(users(:one))
    patch parkrun_path(@parkrun), params: { parkrun: { name: @parkrun.name + 'A' } }
    assert_redirected_to parkruns_path
  end

  test "should destroy parkrun" do
    sign_in_as(users(:one))
    assert_difference("Parkrun.count", -1) do
      delete parkrun_path(@parkrun)
    end

    assert_redirected_to parkruns_path
  end
end
