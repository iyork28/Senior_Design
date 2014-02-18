class AddDefaultToPaymentConfirmed < ActiveRecord::Migration
  def change
    change_column :payments, :confirmed, :boolean, :default => false
  end
end
