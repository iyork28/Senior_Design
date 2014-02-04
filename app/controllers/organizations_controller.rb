class OrganizationsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    @organization.set_password(params[:organization][:password]);
    @organization.save

    @membership = Membership.new(organization: @organization, user: current_user, admin: true)
    @membership.save

    redirect_to :controller => 'welcome', :action => 'dashboard'
  end

  private
    def organization_params
      params.require(:organization).permit(:name)
    end
end
