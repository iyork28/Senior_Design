require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get edit_account_information" do
    get :edit_account_information
    assert_response :success
  end

end
