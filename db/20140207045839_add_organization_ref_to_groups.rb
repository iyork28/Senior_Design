class AddOrganizationRefToGroups < ActiveRecord::Migration
  def change
    add_reference :groups, :organization
  end
end
