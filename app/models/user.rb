class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :organizations, through: :memberships
  has_many :managed_organizations, -> { where('organizations_users.admin = ?', true) },
           :through => :memberships, :source => :organization
  has_many :memberships
  
  def full_name
     [first_name, last_name].join(' ')
  end
end
