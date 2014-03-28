class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :organizations, through: :memberships
  has_many :managed_organizations, -> { where('organizations_users.admin = ?', true) },
           :through => :memberships, :source => :organization
  has_many :memberships
  has_many :group_memberships
  has_many :groups, through: :group_memberships
  has_many :charges, as: :chargeable
  has_many :payments
  
  def full_name
    [first_name, last_name].join(' ')
  end

  def get_total_balance
    # fill in with payments later
    @organization_charges = 0.0
    self.organizations.each do |o|
      @organization_charges += self.get_balance_for_organization(o)
    end
    return @organization_charges
  end

  def get_balance_for_organization (org)
    # fill in with amounts of payments
    @charges = self.get_all_charges_for_user_from_organization(org)
    @charges_sum = 0
    @charges.each do |charge|
      @charges_sum += charge.amount
    end
    @payments = self.payments.where(organization: org).sum('amount')
    
    return @charges_sum - @payments
  end
  
  def get_all_charges_for_user_from_organization (org)
    @org_charges = Charge.where(organization_id: org, chargeable_id: org, chargeable_type: "Organization")
    @org_charges.keep_if{|charge| charge.due_date.midnight >= org.get_membership_timestamp_for_user(self).midnight}
    @personal_charges = Charge.where(organization_id: org, chargeable_id: self, chargeable_type: 'User')
    @personal_charges.keep_if{|charge| charge.due_date.midnight >= self.created_at.midnight}
    @group_charges = Array.new
    
    self.groups.where(organization: org).each do |g|
      @group_charges += Charge.where(organization_id: org, chargeable_id: g, chargeable_type: 'Group')
      @group_charges.keep_if{|charge| charge.due_date.midnight >= g.get_membership_timestamp_for_user(self).midnight}
    end
    
    return @group_charges + @org_charges + @personal_charges
  end
  
  def get_outstanding_balance_for_group(group)
    #returns zero when the user has more payment value than charge value (credit situation)
    @user_balance_for_group = 0
    @user_charges = self.get_all_charges_for_user_from_organization(group.organization).sort_by(&:due_date)
    @user_payments = self.get_all_payments_for_user_from_organization(group.organization).sort_by(&:created_at)
    @partial_payment = 0;
    
    if (!@user_payments.empty?)
      @current_payment = @user_payments.first.amount
    end
    if (!@user_charges.empty?)
      @current_charge = @user_charges.first.amount
    end
    while (!@user_payments.empty?) && (!@user_charges.empty?) do
      if (@current_payment > @current_charge)
        @current_payment -= @current_charge
        @user_charges.delete_at(0)
        if (@user_charges.first != nil)
          @current_charge = @user_charges.first.amount
        end
      elsif (@current_payment < @current_charge)
        @partial_payment = @current_payment
        @current_charge -= @current_payment
        @user_payments.delete_at(0)
        if (@user_payments.first != nil)
          @current_payment = @user_payments.first.amount
          @partial_payment = 0;
        end
      else
        @user_charges.delete_at(0)
        if (@user_charges.first != nil)
          @current_charge = @user_charges.first.amount
        end
        @user_payments.delete_at(0)
        if (@user_payments.first != nil)
          @current_payment = @user_payments.first.amount
        end
      end
      
    end
    if (!@user_charges.empty?)
      @charge = @user_charges.first
      if ((@charge.chargeable_type == 'Group') && (@charge.chargeable_id == group.id) && (@charge.organization_id == group.organization_id))
        @user_balance_for_group -= @partial_payment
      end
    end
 
    if (@user_payments.empty?)
      @user_charges.keep_if {|charge| (charge.chargeable_type == 'Group') && (charge.chargeable_id == group.id) && (charge.organization_id == group.organization_id)}
      @user_charges.each do |charge|
        @user_balance_for_group += charge.amount
      end
 
    end
    
    return @user_balance_for_group
  end
  
  def get_all_payments_for_user_from_organization (org)
    @payments = self.payments.where(organization: org)
  end
  
  def get_charges_for_group (group)
    @group_charges = group.charges
  end
  
  def get_balance_for_group (group)
    @group_charges = group.charges.sum('amount')
    return @group_charges
  end
end
