class AddTypeToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :payment_type, :string, :default => 'cash'
  end
end
