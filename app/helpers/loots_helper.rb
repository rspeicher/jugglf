module LootsHelper
  def loot_tell_types(loot)
    s = []
    s << content_tag(:span, 'Best in Slot', :class => 'filter filter_bis'  ) if loot.best_in_slot?
    s << content_tag(:span, 'Situational',  :class => 'filter filter_sit'  ) if loot.situational?
    s << content_tag(:span, 'Rot',          :class => 'filter filter_rot'  ) if loot.rot?
    s << content_tag(:span, 'Disenchanted', :class => 'filter filter_de'   ) if loot.member_id.nil?
    s << content_tag(:span, 'Normal',       :class => 'filter filter_none' ) if s.empty?
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
