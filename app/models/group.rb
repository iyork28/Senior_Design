class Group < ActiveRecord::Base
  belongs_to :organization
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships
  validates_presence_of :name, :organization
  has_many :charges, as: :chargeable
end
