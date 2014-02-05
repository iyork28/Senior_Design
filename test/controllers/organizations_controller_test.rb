require 'test_helper'
include Devise::TestHelpers

class OrganizationsControllerTest < ActionController::TestCase
  test "should get new" do
    sign_in User.first
    get :new
    assert_response :success
  end

end
