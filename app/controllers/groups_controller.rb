class GroupsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @org = Organization.find(params[:org_id])
  end
  
  def show
    @group = Group.find(params[:id])
  end
  
  def edit
    
  end
end
