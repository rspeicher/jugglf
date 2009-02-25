# == Schema Information
# Schema version: 20090224005026
#
# Table name: mgdkp_items
#
#  item_id          :integer(4)      not null, primary key
#  item_name        :string(255)
#  item_buyer       :string(50)
#  raid_id          :integer(4)      default(0), not null
#  item_value       :float           default(0.0), not null
#  item_date        :integer(4)      default(0), not null
#  item_added_by    :string(30)      default(""), not null
#  item_updated_by  :string(30)
#  item_group_key   :string(32)
#  item_situational :boolean(1)      not null
#  item_bis         :boolean(1)      not null
#

class LegacyItem < ActiveRecord::Base
  set_table_name "mgdkp_items"
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
        raise "Item purchased by invalid member #{self.item_buyer}"
      else
        return m.id
      end
    end
  end

  def rot?
    self.item_value == 0.50
  end
end
