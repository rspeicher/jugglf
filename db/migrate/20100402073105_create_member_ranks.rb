class CreateMemberRanks < ActiveRecord::Migration
  def self.up
    create_table :member_ranks do |t|
      t.string :name, :null => false
      t.string :prefix
      t.string :suffix
    end
  end

  def self.down
    drop_table :member_ranks
  end
end
