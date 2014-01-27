class CreateAdminsOrganizationsJoin < ActiveRecord::Migration
  def change
    create_table :admins_organizations do |t|
      t.integer "user_id"
      t.integer "organization_id"
    end
    add_index :admins_organizations, ["user_id", "organization_id"]
  end
end
