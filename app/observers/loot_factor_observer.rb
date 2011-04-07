class LootFactorObserver < ActiveRecord::Observer
  observe :loot, :raid, :punishment

  def after_destroy(record)
    if record.is_a? Loot
      loot_observer(record)
    elsif record.is_a? Punishment
      punishment_observer(record)
    elsif record.is_a? Raid
      raid_observer(record)
    end
  end

  def after_save(record)
    if record.is_a? Loot
      loot_observer(record)
    elsif record.is_a? Punishment
      punishment_observer(record)
    elsif record.is_a? Raid
      raid_observer(record)
    end
  end

  protected

  def loot_observer(loot)
    # No need to update member cache if we don't have a member
    return unless loot.member_id.present?

    # No need to update member cache if the raid is going to do it for us later
    return if loot.raid_id.present? and loot.raid.changed?

    loot.member.update_cache

    # Update the previous buyer's LF so they don't carry the extra LF until the next full recache
    if previous_buyer = loot.changes['member_id']
      Member.find(previous_buyer[0]).update_cache unless previous_buyer[0].nil?
    end
  end

  def punishment_observer(punishment)
    punishment.member.update_cache unless punishment.member_id.nil?
  end

  def raid_observer(raid)
    # We have to update all members' cache, because even if a member didn't attend
    # this raid, it should still affect that person's attendance percentages
    Member.update_cache unless @update_cache == false

    # Set the purchased_on value of this raid's loots to its current date
    # FIXME: Technically this shouldn't need to be run after save; just update
    # On create, the purchased_on date gets set by Raid#parse_drops
    raid.loots.each do |l|
      unless l.purchased_on == raid.date.to_date
        l.update_attributes(:purchased_on => raid.date)
      end
    end
  end
end
