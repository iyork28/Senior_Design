class Membership < ActiveRecord::Base
  self.table_name = 'organizations_users'
  timestamp = DateTime.new
  
  belongs_to :user
  belongs_to :organization
  before_save :get_timestamp


  def get_timestamp
    self.timestamp = DateTime.now
  end
  
end