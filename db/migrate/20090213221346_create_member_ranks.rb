class CreateMemberRanks < ActiveRecord::Migration
  def self.up
    create_table :member_ranks do |t|
      t.string :name
      t.string :prefix
      t.string :suffix
    end
    
    add_column :members, :rank_id, :integer
    add_index :members, :rank_id
  end

  def self.down
    remove_index :members, :rank_id
    remove_column :members, :rank_id
    drop_table :member_ranks
  end
end
