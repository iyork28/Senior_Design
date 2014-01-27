class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :managed_organizations, class_name: "Organization", join_table: "admins_organizations"
  
  def full_name
     [first_name, last_name].join(' ')
  end
end
