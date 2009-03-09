class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.references :member, :null => false
      t.integer :user_id, :null => false
    end
    
    add_index :memberships, :member_id
    add_index :memberships, :user_id
    add_index :memberships, [:member_id, :user_id], :unique => true
  end

  def self.down
    drop_table :memberships
  end
end
