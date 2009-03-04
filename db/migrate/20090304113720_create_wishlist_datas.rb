class CreateWishlistDatas < ActiveRecord::Migration
  def self.up
    create_table :wishlist_datas do |t|
    end
  end

  def self.down
    drop_table :wishlist_datas
  end
end
