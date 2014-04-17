class AddTimestampToOrganizationsUsers < ActiveRecord::Migration
  def change
    add_column :organizations_users, :timestamp, :datetime
  end
end
