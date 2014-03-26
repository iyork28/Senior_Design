class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def edit_account_information
    @user = current_user
    if request.post?
      @validate_submit = params[:validate_submit] == "true"
      if (@validate_submit)
         @temp_fname = params[:first_name]
         @temp_lname = params[:last_name]
         @temp_email = params[:email]
         if (@temp_fname != nil && !@temp_fname.empty?)
           @user.first_name = @temp_fname
         end
         if (@temp_lname != nil && !@temp_lname.empty?)
           @user.last_name = @temp_lname
         end
         if (@temp_email != nil && !@temp_email.empty?)
           @user.email = @temp_email
         end
         @user.save
      end
      redirect_to dashboard_url
    end
  end
  
  def destroy
    
  end
end
