class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :organization_id
      t.float   :amount
      t.boolean :confirmed
      t.timestamps
    end
  end
end
