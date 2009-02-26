module ItemsHelper
  def item_tell_types(item)
    s = []
    s << "<span class='filter bis'>Best in Slot</span>" if item.best_in_slot?
    s << "<span class='filter sit'>Sit</span>" if item.situational?
    s << "<span class='filter rot'>Rot</span>" if item.rot?
    s << "<span class='filter de'>Disenchanted</span>" if item.buyer.nil?
    s.join(' ')
  end
  
  def item_row_classes(item)
    s = ''
    s << ' item_bis' if item.best_in_slot?
    s << ' item_sit' if item.situational?
    s << ' item_rot' if item.rot?
    s << ' item_de' if item.buyer.nil?
    s.strip
  end
end
