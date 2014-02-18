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
    @users = Organization.find(params[:id]).users
  end

  def edit_admins
    @organization = Organization.find(params[:id])
    @membership = Membership.where(user: current_user, organization: @organization, admin: true)
    if not @membership.exists?
      redirect_to controller: 'welcome', action: 'dashboard'
    end
    if request.post?
      @adminstoremove = params["adminstoremove"]
      if @adminstoremove
        @adminstoremove.each do |a|
          membershiptochange = Membership.find_by(user_id: a, organization_id: @organization )
          membershiptochange.admin = false
          membershiptochange.save
        end
      end
      @newadmins = params["newadmins"]
      if @newadmins
        @newadmins.each do |u|
          membershiptochange = Membership.find_by(user_id: u, organization_id: @organization)
          membershiptochange.admin = true
          membershiptochange.save
        end
      end
    end
    @adminids = Membership.where(organization: @organization).where(admin: true).where('user_id != ?',current_user.id).pluck(:user_id)
    @currentadmins = User.where(id: @adminids)
    @userids = Membership.where(organization: @organization).where(admin: false).pluck(:user_id)
    @users = User.where(id: @userids)
  end

  def create_charge
    @organization = Organization.find(params[:id])
    @users = @organization.users.order(:last_name)
    @groups = @organization.groups.order(:name)
    if request.post?
      @chargeable = nil
      @charge_to = params[:charge_to]

      case @charge_to
        when 'user'
          @chargeable = User.find(params[:user])
        when 'group'
          @chargeable = Group.find(params[:group])
        when 'organization'
          @chargeable = @organization
      end
      @amount = params[:amount]
      @description = params[:description]
      @due_date = params[:due_date]

      if @chargeable != nil then
        @charge = @chargeable.charges.build(amount: @amount, description: @description, due_date: @due_date, organization: @organization)
        @charge.save
        redirect_to dashboard_url
      end
    end
  end
  
  def create_group
    @org = Organization.find(params[:id])
    @users = @org.users
    
    if request.post?
      group = Group.new
      group.name = params[:name]
      group.organization = Organization.find(params[:id])
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
  
  def view_groups
    @org = Organization.find(params[:id])
    @groups = @org.groups
  end
  
  def create_payment
    @organization = Organization.find(params[:id])
    @balance = current_user.get_balance_for_organization(@organization)
    
    if request.post?
      @type = "card"
      if params[:cash_or_check]
        @type = params[:cash_or_check]
      end
      @amount_in_cents = (params[:amount].to_f * 100).to_i
      @amount =  @amount_in_cents / 100.0

      @payment = Payment.new(amount: @amount, user_id: current_user.id, organization_id: params[:id], payment_type: @type, )
      @payment_failed = false

      if params[:stripeToken]
        begin
          customer = Stripe::Customer.create(
              :email => current_user.email,
              :card  => params[:stripeToken]
          )

          charge = Stripe::Charge.create(
              :customer    => customer.id,
              :amount      => @amount_in_cents,
              :description => @organization.name + " payment",
              :currency    => 'usd'
          )
        rescue Stripe::CardError => e
          flash[:error] = e.message
          @payment_failed = true
        end
      end

      if not @payment_failed and @payment.save
        redirect_to dashboard_path
      else
        flash[:notice] = "Payment Creation Failed"
      end
    end
  end

  private
    def organization_params
      params.require(:organization).permit(:name)
    end
end
