module ItemsHelper
  def item_tell_types(item)
    s = ''
    s << ' Best in Slot' if item.best_in_slot?
    s << ' Sit' if item.situational?
    s << ' Rot' if item.rot?
    s << ' Disenchanted' if item.buyer.nil?
    s.strip
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
