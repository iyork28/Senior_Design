class GroupsController < ApplicationController
  before_filter :authenticate_user!
  def new
    @org = Organization.find(params[:org_id])
    @group = Group.new
  end

  def create
  end
end
