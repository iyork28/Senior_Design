class MoveAdminAttributeToUserOrganizationTable < ActiveRecord::Migration
  def change
    # loses previous admin data, but shouldn't matter since no data is in your database at this point
    drop_table :admins_organizations
    add_column :organizations_users, :admin, :boolean, :default => false
  end
end
