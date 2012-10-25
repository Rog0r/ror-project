require 'test_helper'

class OfficeHoursControllerTest < ActionController::TestCase
  setup do
    @office_hour = office_hours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:office_hours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create office_hour" do
    assert_difference('OfficeHour.count') do
      post :create, office_hour: { day: @office_hour.day, open_from: @office_hour.open_from, open_to: @office_hour.open_to }
    end

    assert_redirected_to office_hour_path(assigns(:office_hour))
  end

  test "should show office_hour" do
    get :show, id: @office_hour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @office_hour
    assert_response :success
  end

  test "should update office_hour" do
    put :update, id: @office_hour, office_hour: { day: @office_hour.day, open_from: @office_hour.open_from, open_to: @office_hour.open_to }
    assert_redirected_to office_hour_path(assigns(:office_hour))
  end

  test "should destroy office_hour" do
    assert_difference('OfficeHour.count', -1) do
      delete :destroy, id: @office_hour
    end

    assert_redirected_to office_hours_path
  end
end
