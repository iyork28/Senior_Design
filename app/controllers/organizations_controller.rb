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

  def join
    if request.post?
      @organization = Organization.find(params[:organization])
      if @organization.is_password?(params[:password])
        @membership = Membership.where(user: current_user, organization: @organization)
        if not @membership.exists?
          @membership = Membership.new(organization: @organization, user: current_user)
          @membership.save
        end
        redirect_to controller: 'welcome', action: 'dashboard'
      else
        # do nothing, let fall through
      end
    end
    @organizations = Organization.order(:name)
  end
  
  def list_users
    
  end

  def add_admins
    @organization = Organization.find(params[:id])
    @membership = Membership.where(user: current_user, organization: @organization, admin: true)
    if not @membership.exists?
      redirect_to controller: 'welcome', action: 'dashboard'
    end
    @userids = Membership.where(organization: @organization).where(admin: false).pluck(:user_id)
    @users = User.where(id: @userids)
    if request.post?
      @users.each do |u|
          puts u.full_name
          @param = params[u.id.to_s]
          if @param
            puts @param.to_s
            membershiptochange = Membership.find_by(user: u, organization: @organization)
            membershiptochange.admin = true
            membershiptochange.save
            puts membershiptochange.admin.to_s
          end
      end
      redirect_to controller: 'welcome', action: 'dashboard'
    end
  end

  def remove_admins
    @organization = Organization.find(params[:id])
    @membership = Membership.where(user: current_user, organization: @organization, admin: true)
    if not @membership.exists?
      redirect_to controller: 'welcome', action: 'dashboard'
    end
    @userids = Membership.where(organization: @organization).where(admin: true).where('user_id != ?',current_user.id).pluck(:user_id)
    @users = User.where(id: @userids)
    if request.post?
      @users.each do |u|
          @param = params[u.id.to_s]
          if @param
            membershiptochange = Membership.find_by(user: u, organization: @organization)
            membershiptochange.admin = false
            membershiptochange.save
          end
      end
      redirect_to controller: 'welcome', action: 'dashboard'
    end
  end

  private
    def organization_params
      params.require(:organization).permit(:name)
    end
end
