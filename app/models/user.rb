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
    @org_charges = org.charges.sum('amount')
    @personal_org_charges = self.charges.where(organization: org).sum('amount')
    @group_charges = 0.0
    self.groups.where(organization: org).each do |g|
      @group_charges += self.get_balance_for_group(g)
    end
    
    @payments = self.payments.where(organization: org).sum('amount')
    
    return @org_charges + @personal_org_charges + @group_charges - @payments
  end
  
  def get_all_charges_for_user_from_organization (org)
    @org_charges = org.charges
    @personal_org_charges = self.charges.where(organization: org)
    @org_charges.append(@personal_org_charges)
    self.groups.where(organization: org).each do |g|
      @org_charges.append(g.charges)
    end
    return @org_charges
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
