class PaymentPlanModification < ActiveRecord::Base
  belongs_to :charge
  belongs_to :user
end
