class Charge < ActiveRecord::Base
  belongs_to :organization
  belongs_to :chargeable, :polymorphic => true
  belongs_to :group
end
