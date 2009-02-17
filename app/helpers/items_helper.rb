module ItemsHelper
  def item_tell_types(item)
    s = ''
    s << ' Best in Slot' if item.best_in_slot?
    s << ' Sit' if item.situational?
    s << ' Rot' if item.rot?
    s << ' Disenchanted' if item.buyer.nil?
    s.strip
  end
end
