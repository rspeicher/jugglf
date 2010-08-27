module WishlistData
  def zone(name)
    return if name.blank?
    LootTable.create(:object => Zone.create(:name => name))
  end

  def boss(zone, name)
    return if zone.nil? or name.blank?
    zone.children.create(:object => Boss.create(:name => name))
  end

  def item(boss, name, note = nil)
    return if boss.nil? or name.blank?
    boss.children.create(:object => Item.find_or_create_by_name_or_id(name), :note => note)
  end

  # Convert a boss or zone tag into a full name
  #
  # === Examples
  #
  #   >> tag_to_name('icecrown-25')
  #   => "Icecrown (25)"
  #   >> tag_to_name('the-lich-king-10-hard')
  #   => "The Lich King (10H)"
  def tag_to_name(tag)
    if tag =~ /(.+)-(10|25)(?:-(hard))?/
      size = $2
      hard = $3 ? 'H' : ''
      name = $1.gsub('-', ' ').titleize

      "#{name} (#{size}#{hard})"
    end
  end
end
