class GroupsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @org = Organization.find(params[:org_id])
  end
  
  def show
    @group = Group.find(params[:id])
  end
  
  def edit
    @group = Group.find(params[:id])
    @org = @group.organization
    @users = @org.users
    
    if request.post?
      current_group_ids = @group.user_ids
      new_group_ids     = params[:group_members]
      @new_group_ids    = new_group_ids
      if current_group_ids.nil?
        current_group_ids = []
      end
      if new_group_ids.nil?
        new_group_ids = []
      end
      
      members_to_remove = GroupMembership.where(user_id: (current_group_ids - new_group_ids))
      members_to_add    = new_group_ids - current_group_ids
      
      members_to_remove.each do |m|
        m.destroy
      end
      
      # Note, these are user_ids, not GroupMembership objects
      members_to_add.each do |user_id|
        GroupMembership.create(group_id: @group.id, user_id: user_id)
      end
      
      
    end
  end
  
  def delete
    @group = Group.find(params[:id])
  end
  
  def destroy
    group = Group.find(params[:id])
    group.destroy
    flash[:success] = "Deleted Group #{group.name}"
    redirect_to controller: 'organizations', action: 'view_groups', id: group.organization_id
  end
end
