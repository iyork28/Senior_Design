require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user creation" do
    @user = User.new(email: 'clay@goddard.com', first_name: 'clay',
                     last_name: 'goddard', password: '123123123')
    @user.save

    assert User.exists?(:email => 'clay@goddard.com')
  end

  test "user creation already exists" do
    @user = User.new(email: 'clay@clay.com', first_name: 'clay',
                     last_name: 'goddard', password: '123123123')
    assert_not @user.save
  end

  test "user creation empty password" do
    @user = User.new(email: 'clay@clays.com', first_name: 'clay',
                     last_name: 'goddard', password: '')
    assert_not @user.save
  end
end
