class LegacyItem < ActiveRecord::Base
  set_table_name "mgdkp_items"
  set_primary_key "item_id"
  
  def name
    self.item_name
  end
  
  def price
    if self.rot?
      9999.00
    else
      self.item_value
    end
  end
  
  def situational
    self.item_situational
  end
  def situational?
    self.item_situational
  end
  
  def best_in_slot
    self.item_bis
  end
  def best_in_slot?
    self.item_bis
  end
  
  def member_id
    if self.item_buyer == 'Juggernaut'
      return nil
    else
      m = Member.find_by_name(self.item_buyer)
      if m.nil?
        puts "Item purchased by invalid member #{self.item_buyer}"
        logger.warn "Item purchased by invalid member #{self.item_buyer}"
        return nil
      else
        return m.id
      end
    end
  end
  
  # def raid_id
  #   self.raid_id # NOTE: This will not match the new converted raid's ID
  # end

  def rot?
    self.item_value == 0.50
  end
end
