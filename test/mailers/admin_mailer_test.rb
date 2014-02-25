require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase
  tests AdminMailer
  
  test "cash_payment_confirmation_email" do
    email = AdminMailer.cash_payment_confirmation_email(users(:clay), users(:ian)).deliver
    # Test delivery
    assert !ActionMailer::Base.deliveries.empty?
    
    # Test body of the email
    assert_equal ["#{users(:clay).email}"], email.to
    assert_equal ['notification@example.com'], email.from
    assert_equal "Payment Submitted by #{users(:ian).full_name}", email.subject
  end
end
