# == Schema Information
#
# Table name: items
#
#  id              :integer(4)      not null, primary key
#  name            :string(100)
#  wishlists_count :integer(4)      default(0)
#  loots_count     :integer(4)      default(0)
#  wow_id          :integer(4)
#  color           :string(15)
#  icon            :string(255)
#  level           :integer(4)      default(0)
#  slot            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  heroic          :boolean(1)
#  authentic       :boolean(1)
#

class Item < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  has_many :loots, :dependent => :destroy
  has_many :wishlists, :order => 'priority', :dependent => :destroy
  has_many :loot_tables, :as => :object, :dependent => :destroy
  
  # Attributes ----------------------------------------------------------------
  attr_accessible :name, :wow_id, :color, :icon, :level, :slot, :heroic
  
  searchify :name
  def self.search_name_or_wow_id(query, options={})
    if query =~ /^\d+$/ or query.is_a? Fixnum
      options.delete(:page)
      self.find_all_by_wow_id(query, options)
    else
      self.search(options.merge!(:name => "%#{query}%"))
    end
  end
  
  # Validations ---------------------------------------------------------------
  validates_uniqueness_of :name, :scope => :wow_id
  validates_uniqueness_of :wow_id
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  # Allows the user to pass either an integer to FoC by wow_id, or a string to FoC by name
  def self.find_or_create_by_name_or_wow_id(value)
    if value =~ /^\d+$/ or value.is_a? Fixnum
      self.find_or_create_by_wow_id(value)
    else
      self.find_or_create_by_name(value)
    end
  end
  
  def self.find_by_name_or_wow_id(value)
    if value =~ /^\d+$/ or value.is_a? Fixnum
      self.find_by_wow_id(value)
    else
      self.find_by_name(value)
    end
  end
  
  # Instance Methods ----------------------------------------------------------
  def needs_lookup?
    !self.authentic?
  end
  
  def lookup!(force_refresh = false)
    self.lookup(force_refresh)
    self.save
  end
  def lookup(force_refresh = false)
    if force_refresh or self.needs_lookup?
      stat_lookup(self.wow_id || self.name)
    end
  end
  
  def to_param
    return self.id.to_s if self.name.nil?
    
    "#{self.id}-#{self.name.parameterize}-#{self.wow_id}".gsub(/\-$/, '')
  end
  
  protected
    def validate
      self.lookup
      
      unless self.authentic?
        self.errors.add_to_base("Attempted to save an invalid item")
      end
    end
    
    # Given a +query+, either a WoW ID or an Item name, performs an item lookup
    # via wowarmory.com
    #
    # Sets the following attributes on the current +Item+:
    # - +wow_id+
    # - +name+
    # - +color+
    # - +icon+
    # - +level+
    # - +slot+
    # - +heroic+
    # - +authentic+
    def stat_lookup(query)
      result = ItemLookup.search(query, :source => 'armory').best_result
      if result.valid?
        self.wow_id    = result.id
        self.name      = result.name
        self.color     = result.css_quality
        self.icon      = result.icon
        self.level     = result.level
        self.slot      = result.slot
        self.heroic    = result.heroic
        self.authentic = true
        
        return true
      else
        return false
      end
    end
end
