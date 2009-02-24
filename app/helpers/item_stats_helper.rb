module ItemStatsHelper
  def link_to_wowhead(item)
    stat = ItemStat.lookup(item.name)
    
    "<a href='#{stat.wowhead_link}' class='#{stat.color}'>#{h(item.name)}</a>" unless stat.nil?
  end
  
  def link_to_item_with_stats(item)
    stat = ItemStat.lookup(item.name)
    
    "<a href='#{item_path(item)}' rel='item=#{stat.item_id}' class='#{stat.color}'>#{h(item.name)}</a>" unless stat.nil?
  end
end