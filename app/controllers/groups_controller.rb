class GroupsController < ApplicationController
  before_filter :authenticate_user!
  def new
    @org = Organization.find(params[:org_id])
    @users = @org.users
    
    if request.post?
      group = Group.new
      group.name = params[:name]
      group.organization = params[:org_id]
      if group.save
        User.find(params[:added_users]).each do |user|
          GroupMembership.create(group_id: group.id, user_id: user.id)
        end
        flash[:notice] = "Group Created"
        redirect_to dashboard_path
      else
        flash[:notice] = "Group Creation Failed"
      end
    end
  end

  def create
  end
  
  def index
    @org = Organization.find(params[:org_id])
  end
end
