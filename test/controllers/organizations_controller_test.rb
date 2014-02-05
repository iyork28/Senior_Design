require 'test_helper'
include Devise::TestHelpers

class OrganizationsControllerTest < ActionController::TestCase
  test "should get new" do
    sign_in User.first
    get :new
    assert_response :success
    assert assigns(:organization)
  end

  test "create" do
    @user = User.first
    sign_in @user

    @name = 'test create'
    @password = '123'

    @count_before = Organization.count
    post(:create, organization: { name: @name, password: @password })
    @count_after = Organization.count
    @created_org = assigns(:organization)

    assert_equal @created_org.name, @name
    assert @created_org.is_password?(@password)
    assert_equal @count_after - 1, @count_before
    assert @created_org.admins.exists?(@user)
    assert_response :redirect
  end

  test "join" do
    @user = User.first
    sign_in @user
    @org_no_members = Organization.find(666)

    @membership_count_before = Membership.count
    post(:join, { organization: @org_no_members.id, password: 123 })
    @membership_count_after = Membership.count
    @created_membership = assigns(:membership)

    assert_equal @membership_count_after - 1, @membership_count_before
    assert_equal @created_membership.admin, false
    assert_response :redirect
  end

  test "join wrong password" do
    @user = User.first
    sign_in @user
    @org_no_members = Organization.find(666)

    @membership_count_before = Membership.count
    post(:join, { organization: @org_no_members.id, password: 123456 })
    @membership_count_after = Membership.count

    assert_equal @membership_count_after, @membership_count_before
    assert_not assigns(:membership)
    assert_response :success
  end
end
