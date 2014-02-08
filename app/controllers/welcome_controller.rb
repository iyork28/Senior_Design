class WelcomeController < ApplicationController
  before_filter :authenticate_user!,
                :except => [:index]

  def index
    if user_signed_in?
      redirect_to dashboard_url
    end
  end

  def dashboard
    @organizations = current_user.organizations.order(:name)
  end

end
