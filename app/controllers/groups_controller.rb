class GroupsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @org = Organization.find(params[:org_id])
  end
end
