class Membership < ActiveRecord::Base
  self.table_name = 'organizations_users'
  timestamp = DateTime.new
  
  belongs_to :user
  belongs_to :organization

  before_save :get_timestamp

  def get_timestamp
    if (self.timestamp == nil)
      self.timestamp = DateTime.new
    end
    self.timestamp = DateTime.now
  end
  
end