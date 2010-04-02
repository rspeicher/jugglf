class RenamePunishmentExpires < ActiveRecord::Migration
  def self.up
    rename_column :punishments, :expires, :expires_on
  end

  def self.down
    rename_column :punishments, :expires_on, :expires
  end
end
