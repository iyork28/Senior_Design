class ChargeModification < ActiveRecord::Base
  belongs_to :user
  belongs_to :charge
end
