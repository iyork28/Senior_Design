class AddOrganizationRefToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :organization, :reference
  end
end
