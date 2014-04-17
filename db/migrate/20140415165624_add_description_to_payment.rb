class AddDescriptionToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :description, :text, :null => true
  end
end
