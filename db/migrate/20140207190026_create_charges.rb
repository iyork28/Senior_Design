class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :description
      t.float :amount
      t.references :organization, index: true
      t.references :chargeable, :polymorphic => true
      t.date :due_date

      t.timestamps
    end
  end
end
