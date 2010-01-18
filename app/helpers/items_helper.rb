module ItemsHelper
  def link_to_wowhead(item, options = {})
    return if item.nil?
    item = stat_lookup(item)
    
    wowhead_link(item, options)
  end
  
  def link_to_item_with_stats(item, options = {})
    return if item.nil? or item.name.nil?
    item = stat_lookup(item)
    
    options[:rel] ||= true
    wowhead_link(item, options)
  end
  
  def wowhead_item_icon(icon, size = 'small')
    size = size.to_s if size.respond_to? 'to_s'
    
    if icon.present?
      "http://static.wowhead.com/images/icons/#{size.downcase}/#{icon.downcase}.jpg"
    else
      ''
    end
  end
  
  private
    def stat_lookup(item)
      if item.id.nil?
        item.lookup
      end
      
      item
    end
    
    def wowhead_link(item, options = {})
      return if item.nil?
      
      options[:rel] ||= false
    
      if options[:rel]
        link_to(truncate(h(item.name), :length => 80), item_path(item), 
          :class => item.color, :rel => "item=#{item.id}").gsub(/"/, "'")
      else
        link_to(truncate(h(item.name), :length => 80), "http://www.wowhead.com/?item=#{item.id}", 
          :class => item.color, :target => '_new').gsub(/"/, "'")
      end
    end
end
