class Charge < ActiveRecord::Base
  belongs_to :organization
  belongs_to :chargeable, :polymorphic => true
  validates_presence_of :due_date
  has_many :charge_modifications
  has_many :payment_plan_modifications
  def + rhs
    rhs.amount + self.amount
  end
end
