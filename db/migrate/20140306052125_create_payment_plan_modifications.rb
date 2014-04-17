class CreatePaymentPlanModifications < ActiveRecord::Migration
  def change
    create_table :payment_plan_modifications do |t|
      t.references :charge, index: true
      t.references :user, index: true
      t.float :amount
      t.date :due_date

      t.timestamps
    end
  end
end
