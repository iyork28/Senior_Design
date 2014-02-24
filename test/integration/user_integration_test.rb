require 'test_helper'

class UserIntegrationTest < ActionDispatch::IntegrationTest
  test "user sign in fail" do
    visit new_user_session_path
    fill_in 'user_email', with: 'clay@goddard.com'
    fill_in 'user_password', with: '123'
    click_button 'Sign in'
    save_and_open_page
    assert current_path == new_user_session_path
  end
end