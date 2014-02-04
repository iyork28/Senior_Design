class OrganizationAddPasswordColumn < ActiveRecord::Migration
  def change
    # default password for an organization that already existed is 'pass'
    add_column :organizations, :password, :string, default: Digest::SHA1.hexdigest('pass')
  end
end
