class WelcomeController < ApplicationController
  before_filter :authenticate_user!,
                :except => [:index]

  def index
  end

  def dashboard
    @organizations = current_user.organizations
  end

end
