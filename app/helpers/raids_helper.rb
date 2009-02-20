module RaidsHelper
  def raid_date_classes(raid)
    s = ''
    s << ' last_thirty' if raid.is_in_last_thirty_days?
    s << ' last_ninety' if raid.is_in_last_ninety_days?
    s
  end
end
