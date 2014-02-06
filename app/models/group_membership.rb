class GroupMembership < ActiveRecord::Base
  self.table_name = 'groups_users'
  
  belongs_to :user
  belongs_to :group
end
