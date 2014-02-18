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
    @org_charges = org.charges.sum(&:amount)
    @personal_org_charges = self.charges.where(organization: org).sum(&:amount)
    @group_charges = 0.0
    self.groups.where(organization: org).each do |g|
      @group_charges += self.get_balance_for_group(g)
    end
    return @org_charges + @personal_org_charges + @group_charges
  end
  
  def get_balance_for_group (group)
    @group_charges = group.charges.sum(&:amount)
    return @group_charges
  end
end
