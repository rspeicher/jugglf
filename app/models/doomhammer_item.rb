class DoomhammerItem < ActiveRecord::Base
  set_table_name "eqdkp_items"
  set_primary_key "item_id"
  
  def name
    self.item_name
  end
  
  def price
    if self.rot?
      0.50 # 9999.00
    else
      self.item_value
    end
  end
  
  def situational
    self.item_situational
  end
  alias_method :situational?, :situational
  
  # Didn't exist on Doomhammer
  def best_in_slot
    false
  end
  alias_method :best_in_slot?, :best_in_slot
  
  def member_id
    if self.item_buyer == 'Juggernaut'
      return nil
    else
      # Get the DoomhammerMember record so that our renames still work
      dm = DoomhammerMember.find_by_member_name(self.item_buyer)
      m = Member.find_by_name(dm.name)
      if m.nil?
        puts "Item purchased by invalid member #{self.item_buyer}"
      else
        return m.id
      end
    end
  end

  def rot
    self.item_value == 0.50
  end
  alias_method :rot?, :rot
end
