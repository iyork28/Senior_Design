class AddDefaultToPaymentConfirmed < ActiveRecord::Migration
  def up
    change_column :payments, :confirmed, :boolean, :default => false
    Payment.all.each do |p|
      if p.confirmed.nil? then
        p.confirmed = false
        p.save
      end
    end
  end

  def down
    change_column :payments, :confirmed, :boolean, :default => nil
  end
end
