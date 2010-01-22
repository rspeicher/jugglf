module LootsHelper
  def loot_tell_types(loot)
    s = []
    s << "<span class='filter bis'>Best in Slot</span>" if loot.best_in_slot?
    s << "<span class='filter sit'>Situational</span>"  if loot.situational?
    s << "<span class='filter rot'>Rot</span>"          if loot.rot?
    s << "<span class='filter de'>Disenchanted</span>"  if loot.member_id.nil?
    s << "<span class='filter normal'>Normal</span>"    if s.empty?
    s.join(' ')
  end

  def loot_row_classes(loot)
    s = ''
    s << ' loot_bis'    if loot.best_in_slot?
    s << ' loot_sit'    if loot.situational?
    s << ' loot_rot'    if loot.rot?
    s << ' loot_de'     if loot.member_id.nil?
    s << ' loot_normal' if s.empty?
    s.strip
  end

  def loot_factor_cutoff(date)
    from = 52.days.since(date)
    to   = Date.today

    distance = distance_of_time_in_words(from, to)

    if from < to
      distance += ' ago'
    elsif from > to
      distance += ' from today'
    else
      distance = 'Today'
    end

    distance.capitalize
  end
end
