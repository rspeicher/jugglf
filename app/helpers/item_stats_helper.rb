module ItemStatsHelper
  def link_to_wowhead(item)
    return if item.nil?
    item = stat_lookup(item)
    
    wowhead_link(item)
  end
  
  def link_to_item_with_stats(item)
    return if item.nil?
    item = stat_lookup(item)
    
    wowhead_link(item, :rel => true)
  end
  
  private
    def stat_lookup(item)
      if item.item_stat.nil?
        stat = ItemStat.lookup(item.name)
        item.update_attributes(:item_stat_id => stat.id) unless stat.nil?
      end
      
      item
    end
    
    def wowhead_link(item, options = {})
      return if item.nil? or item.item_stat.nil?
      if item.item_stat.wow_id.nil?
        link_to(truncate(h(item.name), :length => 80), item_path(item) + "?refresh",
          :class => 'q0')
      else
        options[:rel] ||= false
      
        if options[:rel]
          link_to(truncate(h(item.name), :length => 80), item_path(item), 
            :class => item.item_stat.color, :rel => "item=#{item.item_stat.wow_id}").gsub(/"/, "'")
        else
          link_to(truncate(h(item.name), :length => 80), item.item_stat.wowhead_link, 
            :class => item.item_stat.color, :target => '_new').gsub(/"/, "'")
        end
      end
    end
end