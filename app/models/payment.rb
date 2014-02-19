class Payment < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  
  def + rhs
    rhs + self.amount
  end
end
