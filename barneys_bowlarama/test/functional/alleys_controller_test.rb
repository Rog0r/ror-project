require 'test_helper'

class AlleysControllerTest < ActionController::TestCase
  setup do
    @alley = alleys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:alleys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create alley" do
    assert_difference('Alley.count') do
      post :create, alley: { number: @alley.number, unlocked: @alley.unlocked }
    end

    assert_redirected_to alley_path(assigns(:alley))
  end

  test "should show alley" do
    get :show, id: @alley
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @alley
    assert_response :success
  end

  test "should update alley" do
    put :update, id: @alley, alley: { number: @alley.number, unlocked: @alley.unlocked }
    assert_redirected_to alley_path(assigns(:alley))
  end

  test "should destroy alley" do
    assert_difference('Alley.count', -1) do
      delete :destroy, id: @alley
    end

    assert_redirected_to alleys_path
  end
end
