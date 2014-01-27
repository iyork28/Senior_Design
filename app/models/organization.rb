class Organization < ActiveRecord::Base
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :admins, class_name: "User", join_table: "admins_organizations"
end
