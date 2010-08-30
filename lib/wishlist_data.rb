# = WishlistData
#
# Provides an interface for defining +LootTable+ objects (i.e., Zone > Boss > Item associations)
#
# == Examples
#
# Icecrown Citadel has many bosses in it, with four dungeon difficulties, each of which have unique loot.
# We might define its wishlist data like so:
#
#   # Zone name is derived from the class name
#   class IcecrownCitadel
#     include WishlistData
#
#     # Create a Zone object (the parent of all boss/item data) named "Icecrown Citadel (10H)"
#     difficulty :heroic_10 do
#
#       # Create a Boss object inside of the zone named "The Lich King"
#       boss "The Lich King" do
#
#         # Add these items to this boss on this difficulty
#         item 52027 #Conqueror's Mark of Sanctification
#         item 51943 #Halion, Staff of Forgotten Love
#         item 52026 #Protector's Mark of Sanctification
#         item 51941 #Pugius, Fist of Defiance
#         item 51942 #Stormfury, Black Blade of the Betrayer
#         item 51945 #Tainted Twig of Nordrassil
#         item 51939 #Tel'thas, Dagger of the Blood King
#         item 51947 #Troggbane, Axe of the Frostborne King
#         item 51944 #Valius, Gavel of the Lightbringer
#         item 52025 #Vanquisher's Mark of Sanctification
#         item 51946 #Warmace of Menethil
#         item 51940 #Windrunner's Heartseeker
#       end
#     end
#   end
#
# On the other hand, Ruby Sanctum only has one boss, so we don't want to create four separate zones and instead
# define the difficulty per-Boss rather than per-Zone:
#
#   class RubySanctum
#     include WishlistData
#
#     boss "Halion", :difficulty => :heroic_10 do
#       # items
#     end
#
#     boss "Halion", :difficulty => :heroic_25 do
#       # items
#     end
#   end
#
# And finally, while we may define four different difficulties, we may decide after some time that we no longer
# care about anything from <tt>:normal_10</tt> or <tt>:normal_25</tt> difficulties. We can ignore that defined data
# by calling <tt>active_difficulties</tt> before the definitions:
#
#   class IcecrownCitadel
#     include WishlistData
#
#     active_difficulties :heroic_10, :heroic_25
#
#     # This is ignored
#     difficulty :normal_10 do
#       # ...
#     end
#
#     # This is ignored
#     difficulty :normal_25 do
#       # ...
#     end
#
#     # This is included
#     difficulty :heroic_10 do
#       # ...
#     end
#
#     # This is included
#     difficulty :heroic_25 do
#       # ...
#     end
#   end
#
# If <tt>active_difficulties</tt> is not called in the class, then it assumes all four difficulties should be used.
# Once a zone is phased out, you can call <tt>active_difficulties :none</tt> to completely ignore the zone.
module WishlistData
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def self.extended(base)
      # Set the default value for @difficulties
      base.instance_variable_set(:@difficulties, [:normal_10, :normal_25, :heroic_10, :heroic_25])

      # Define a zone name based on the class ("WishlistData::IcecrownCitadel" -> "Icecrown Citadel")
      base.instance_variable_set(:@zone_name, base.to_s.demodulize.titleize)
    end

    # Alias for <tt>active_difficulties</tt>
    def active_difficulty(*values)
      active_difficulties(*values)
    end

    # Define the actively-raided difficulties for the current Zone
    def active_difficulties(*values)
      if values.include? :none
        @difficulties = []
      else
        # Change active difficulties to what the user supplies, but only when they supply a difficulty we already know about
        @difficulties = values.reject { |v| not @difficulties.include? v }
      end
    end

    # Creates a +Zone+ object based on the given difficulty
    def difficulty(diff, &block)
      return unless @difficulties.include? diff

      # Difficulty before boss (one zone per difficulty)
      @zone = LootTable.create(:object => Zone.create(:name => @zone_name + shorten_difficulty(diff)))

      yield self
    end

    # Create a +Boss+ object inside of the current +Zone+ table
    def boss(name, options = {}, &block)
      raise ArgumentError, "Boss name is required" unless name.present?

      if options[:difficulty].present?
        return unless @difficulties.include? options[:difficulty]

        @zone ||= LootTable.create(:object => Zone.create(:name => @zone_name))
        @boss = @zone.children.create(:object => Boss.create(:name => name + shorten_difficulty(options[:difficulty])))
      else
        raise "Cannot create a boss without a pre-defined zone object or a difficulty option" if @zone.nil?
        @boss = @zone.children.create(:object => Boss.create(:name => name))
      end

      yield self
    end

    # Add an +Item+ object to the current +Boss+ table
    def item(value, note = nil)
      return unless @boss
      raise ArgumentError, "Must provide an item name or ID" unless value.present?

      @boss.children.create(:object => Item.find_or_create_by_name_or_id(value), :note => note)
    end

    private

    # Shortens a difficulty for use in a zone or boss name
    #
    # === Examples
    #
    #   >> shorten_difficulty(:normal_10)
    #   => " (10)"
    #   >> shorten_difficulty(:heroic_25)
    #   => " (25H)"
    def shorten_difficulty(diff)
      diff = diff.to_s
      diff = diff.gsub(/heroic_(10|25)/, '\1H')
      diff = diff.gsub(/normal_(10|25)/, '\1')

      " (#{diff})"
    end
  end
end
