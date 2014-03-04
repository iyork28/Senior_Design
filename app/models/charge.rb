class Charge < ActiveRecord::Base
  belongs_to :organization
  belongs_to :chargeable, :polymorphic => true
  validates_presence_of :due_date
end
