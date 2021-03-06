class JoinGroupsUsers < ActiveRecord::Migration
  def change
    create_table :groups_users do |t|
      t.integer "group_id"
      t.integer "user_id"
    end
    
    add_index :groups_users, ["group_id", "user_id"]
  end
end
