class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :organization

      t.timestamps
    end
  end
end
