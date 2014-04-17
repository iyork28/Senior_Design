class Group < ActiveRecord::Base
  belongs_to :organization
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships
  validates_presence_of :name, :organization
  validates_uniqueness_of :name
  has_many :charges, as: :chargeable
  
  def get_outstanding_balance
    @outstanding_group_balance = 0;
    self.users.each do |user|
      @outstanding_group_balance += user.get_outstanding_balance_for_group(self)
    end
   
    return @outstanding_group_balance
  end
  
  def get_membership_timestamp_for_user(user)
    @membership = GroupMembership.where(user_id: user.id, group_id: self.id).first
    return @membership.read_attribute(:timestamp)
  end
  
end
