class GroupMembership < ActiveRecord::Base
  self.table_name = 'groups_users'
  timestamp = DateTime.new


  belongs_to :user
  belongs_to :group
  
  before_save :get_timestamp
  

  def get_timestamp
    self.timestamp = DateTime.now
  end
 

end
