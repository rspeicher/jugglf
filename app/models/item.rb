class Item < ActiveRecord::Base
  attr_accessible :name, :color, :icon, :level, :slot, :heroic

  has_many :loots, :dependent => :destroy
  has_many :wishlists, :order => 'priority', :dependent => :destroy
  has_many :loot_tables, :as => :object, :dependent => :destroy

  validates_uniqueness_of :id
  validates_numericality_of :id, :allow_nil => false, :greater_than => 0
  validates_uniqueness_of :name, :scope => :id

  # Legacy support
  #
  # TODO: Remove me
  def wow_id
    self.id
  end

  def to_param
    return self.id.to_s if self.name.nil?

    "#{self.id}-#{self.name.parameterize}"
  end

  def to_s
    "#{self.id}-#{self.name}"
  end

  # Allows the user to pass either an integer to FoC by ID, or a string to FoC by name
  def self.find_or_create_by_name_or_id(value)
    if value =~ /^\d+$/ or value.is_a? Fixnum
      self.find_or_create_by_id(value)
    else
      self.find_or_create_by_name(value)
    end
  end

  def self.find_by_name_or_id(value)
    if value =~ /^\d+$/ or value.is_a? Fixnum
      self.find_by_id(value)
    else
      self.find_by_name(value)
    end
  end

  def needs_lookup?
    !self.authentic?
  end

  def lookup!(force_refresh = false)
    self.lookup(force_refresh)
    self.save
  end
  def lookup(force_refresh = false)
    if force_refresh or self.needs_lookup?
      stat_lookup(self.id || self.name)
    end
  end

  protected

  validate :authenticate
  def authenticate
    self.lookup

    unless self.authentic?
      self.errors.add(:base, "attempted to save an invalid item (#{self.to_s})")
    end
  end

  # Given a +query+, either a WoW ID or an Item name, performs an item lookup
  # via wowarmory.com
  #
  # Sets the following attributes on the current +Item+:
  # - +id+
  # - +name+
  # - +color+
  # - +icon+
  # - +level+
  # - +slot+
  # - +heroic+
  # - +authentic+
  def stat_lookup(query)
    result = ItemLookup.search(query, :source => 'wowhead').best_result
    if result.valid?
      self.id        = result.id
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
