require 'test_helper'
include Devise::TestHelpers

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get dashboard" do
    sign_in User.first
    get :dashboard
    assert_response :success
    assert assigns(:organizations).count == 2
  end
end
