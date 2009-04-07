class DoomhammerMember < ActiveRecord::Base
  set_table_name "eqdkp_members"
  set_primary_key "member_id"
  
  def name
    ret = self.member_name
    case ret
    when 'Ayani'
      ret = 'Inaya'
    when 'Figoo'
      ret = 'Paiynus'
    when 'Grimx'
      ret = 'Leowon'
    when 'Kamien'
      ret = 'Tsigo'
    when 'Kartane'
      ret = 'Karttane'
    when 'Methos'
      ret = 'Baud'
    when 'Modrack'
      ret = 'Modk'
    when 'Paragon'
      ret = 'Parawon'
    when 'Zugzwang'
      ret = 'Alephone'
    end
    
    ret
  end
  
  def active
    self.member_status and self.member_rank_id != 5 and self.member_rank_id != 6
  end
  def active?
    self.active
  end
  
  def wow_class
    self.member_class.titlecase unless self.member_class.downcase == 'bank'
  end
  
  def rank_id
    self.member_rank_id
  end
end
