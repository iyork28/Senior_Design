class OrganizationsController < ApplicationController
  before_filter :authenticate_user!
  before_action :check_admin!, only: [:organization_admin, :edit_admins, :create_charge, :delete_charge, :admin_view_org_member, :admin_remove_user, :edit_organization_information, :pending_payments, :view_groups]

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
  

  def organization_admin
    @organization = Organization.find(params[:id])
    @membership = Membership.where(user: current_user, organization: @organization, admin: true)
    if not @membership.exists?
      redirect_to controller: 'welcome', action: 'dashboard'
    end
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

  def request_reimbursement
    @organization = Organization.find(params[:id])
    
    if request.post?
      @type = "reimbursement"
      @amount_in_cents = (params[:amount].to_f * 100).to_i
      @amount =  @amount_in_cents / 100.0
      @description = params[:description]

      @payment = Payment.new(amount: @amount, user_id: current_user.id, organization_id: @organization.id, payment_type: @type, description: @description)

      @membership = Membership.where(user: current_user, organization: @organization, admin: true)
      if @membership.exists?
        @payment.confirmed = true # admins are auto approved too
      end

      if @payment.save
        @organization.admins.each do |admin|
          # begin
          #   AdminMailer.cash_payment_confirmation_email(admin, current_user).deliver
          # rescue Exception => e
          #   flash[:error] = e.message
          # end
          # need to add emailing for reimbursement requests
        end
        redirect_to dashboard_path
      else
        flash[:error] = "Reimbursement Creation Failed"
      end
    end
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
      @due_date = Chronic.parse(params[:due_date])

      if @chargeable != nil then
        @charge = @chargeable.charges.build(amount: @amount, description: @description, due_date: @due_date, organization: @organization, chargeable: @chargeable)
        @charge.save
        redirect_to dashboard_url
      end
    end
  end

  def edit_charge
    @charge = Charge.find(params[:charge_id])
    @organization = Organization.find(params[:id])
    @users = @organization.users.order(:last_name)
    @groups = @organization.groups.order(:name)
    if request.post?
      @chargeable = nil
      @charge_to = params[:charge_to]

      case @charge_to
        when 'User'
          @chargeable = User.find(params[:user])
        when 'Group'
          @chargeable = Group.find(params[:group])
        when 'Organization'
          @chargeable = @organization
      end
      @charge.amount = params[:amount]
      @charge.description = params[:description]
      @charge.due_date = Chronic.parse(params[:due_date])
      @charge.chargeable_id = @chargeable.id
      @charge.chargeable_type = @charge_to
     
      @charge.save
      redirect_to controller: 'organizations', action: 'view_charges'
   
    end
  end
  
  def delete_charge
    @charge = Charge.find(params[:charge_id])
    @organization = Organization.find(params[:id])
    if request.post?
      @validate_delete = params[:validate_delete] == "true"
      if (@validate_delete)
         @charge.destroy
      end
      redirect_to controller: 'organizations', action: 'view_charges'
   
    end
  end

  def view_charges
    @organization = Organization.find(params[:id])
    @charges = Charge.where(organization_id: @organization.id)
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
        flash[:success] = "Group Created"
        redirect_to dashboard_path
      else
        flash[:fail] = "Group Creation Failed"
      end
    end
  end
  
  def view_groups
    @org = Organization.find(params[:id])
    @groups = @org.groups
  end
  
  def view_organization_charges
    @org = Organization.find(params[:id])
    @groups = @org.groups
    @charges = current_user.get_all_charges_for_user_from_organization(@org).sort_by(&:due_date)
    @payments = current_user.get_all_payments_for_user_from_organization(@org).sort_by(&:created_at)
    @payments_total = @payments.sum(&:amount)
  end
  
  def view_organization_members
    @org = Organization.find(params[:id])
    @members = @org.users
  end
  
  def admin_view_org_member
    @member = User.find(params[:mid])
    @org = Organization.find(params[:id])
    @charges = @member.get_all_charges_for_user_from_organization(@org).sort_by(&:due_date)
    @payments = @member.get_all_payments_for_user_from_organization(@org).sort_by(&:created_at)
    @payments_total = @payments.sum(&:amount)
  end

  def admin_remove_user
    member = User.find(params[:mid])
    org = Organization.find(params[:id])
    if member != current_user
      admin_membership = Membership.where(user: current_user, organization: org, admin: true)
      if admin_membership.exists?
        membership = Membership.find_by(user: member, organization: org)
        if membership
          membership.delete
          flash[:success] = "Member Removed"
        end
      end
    else
      flash[:error] = "You can't remove yourself"
    end
    redirect_to :controller => 'organizations', :action => 'view_organization_members', :id => org.id
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

      @payment = Payment.new(amount: @amount, user_id: current_user.id, organization_id: params[:id], payment_type: @type)
      @payment_failed = false

      @membership = Membership.where(user: current_user, organization: @organization, admin: true)
      if @membership.exists?
        @payment.confirmed = true # admins are auto approved too
      end

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

          @payment.confirmed = true # card payments always confirmed

        rescue Stripe::CardError => e
          flash[:error] = e.message
          @payment_failed = true
        end
      end

      if not @payment_failed and @payment.save
        @organization.admins.each do |admin|
          begin
            AdminMailer.cash_payment_confirmation_email(admin, current_user).deliver
          rescue Exception => e
            flash[:error] = e.message
          end
        end
        redirect_to dashboard_path
      else
        flash[:error] = "Payment Creation Failed"
      end
    end
  end

  def edit_organization_information
    @organization = Organization.find(params[:id])
    if request.post?
      @validate_submit = params[:validate_submit] == "true"
      if (@validate_submit)
         @temp_name = params[:name]
         if (@temp_name != nil && !@temp_name.empty?)
           @organization.name = @temp_name
         end
    
         @organization.save
      end
      redirect_to :controller => 'organizations', :action => 'organization_admin'
    end
  end

  def pending_payments
    @organization = Organization.find(params[:id])
    @membership = Membership.where(user: current_user, organization: @organization, admin: true)
    if not @membership.exists?
      redirect_to dashboard_path
    end

    if request.post?
      @payment_id = params[:payment_id]
      @payment = Payment.find(@payment_id)
      if params[:approve_or_reject] == 'approve'
        @payment.confirmed = true
        @payment.save
      else params[:approve_or_reject] == 'reject'
        @payment.delete
      end
    end

    @pending_payments = @organization.payments.where(confirmed: false)
  end
  

  private
    def organization_params
      params.require(:organization).permit(:name)
    end
    
    def check_admin!
      if current_user.is_admin_for_org?(params[:id]) == [true]
        # Let them through
      else
        redirect_to root_path, notice:"You don't have permissions to view this"
      end
    end
end
