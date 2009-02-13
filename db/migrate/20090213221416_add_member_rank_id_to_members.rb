class AddMemberRankIdToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :rank_id, :integer
  end

  def self.down
    remove_column :members, :rank_id
  end
end
