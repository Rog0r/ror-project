require 'test_helper'

class ReserveControllerTest < ActionController::TestCase
  test "should get pick" do
    get :pick
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
