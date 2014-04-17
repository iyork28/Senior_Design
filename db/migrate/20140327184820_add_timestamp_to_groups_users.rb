class AddTimestampToGroupsUsers < ActiveRecord::Migration
  def change
    add_column :groups_users, :timestamp, :datetime
  end
end
