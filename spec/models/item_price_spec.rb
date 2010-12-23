require 'spec_helper'

describe ItemPrice do
  include PriceItemMatcher

  subject { ItemPrice.instance }

  it "should validate keys" do
    expect { subject.price(:invalid => 'Something', :id => 12345) }.to raise_error(ArgumentError)
  end

  # Head/Chest/Legs Slot Items
  it { should price_item(:slot => 'Head',  :level => 372).to(3.00) }
  it { should price_item(:slot => 'Head',  :level => 359).to(2.50) }
  it { should price_item(:slot => 'Chest', :level => 372).to(3.00) }
  it { should price_item(:slot => 'Chest', :level => 359).to(2.50) }
  it { should price_item(:slot => 'Legs',  :level => 372).to(3.00) }
  it { should price_item(:slot => 'Legs',  :level => 359).to(2.50) }

  # Shoulder/Hands/Feet Slot Items
  it { should price_item(:slot => 'Shoulder', :level => 372).to(2.50) }
  it { should price_item(:slot => 'Shoulder', :level => 359).to(2.00) }
  it { should price_item(:slot => 'Hands',    :level => 372).to(2.50) }
  it { should price_item(:slot => 'Hands',    :level => 359).to(2.00) }
  it { should price_item(:slot => 'Feet',     :level => 372).to(2.50) }
  it { should price_item(:slot => 'Feet',     :level => 359).to(2.00) }

  # Wrists/Waist/Finger Slot Items
  it { should price_item(:slot => 'Wrist',  :level => 372).to(2.00) }
  it { should price_item(:slot => 'Wrist',  :level => 359).to(1.50) }
  it { should price_item(:slot => 'Waist',  :level => 372).to(2.00) }
  it { should price_item(:slot => 'Waist',  :level => 359).to(1.50) }
  it { should price_item(:slot => 'Finger', :level => 372).to(2.00) }
  it { should price_item(:slot => 'Finger', :level => 359).to(1.50) }

  # Neck/Back Slot Items
  it { should price_item(:slot => 'Neck', :level => 372).to(2.00) }
  it { should price_item(:slot => 'Neck', :level => 359).to(1.50) }
  it { should price_item(:slot => 'Back', :level => 372).to(2.00) }
  it { should price_item(:slot => 'Back', :level => 359).to(1.50) }

  # Two-Hand Weapons
  it { should price_item(:slot => 'Two-Hand', :level => 372, :class => 'Rogue').to(6.00) }
  it { should price_item(:slot => 'Two-Hand', :level => 359, :class => 'Rogue').to(5.00) }
  it { should price_item(:slot => 'Two-Hand', :level => 372, :class => 'Hunter').to(2.50) }
  it { should price_item(:slot => 'Two-Hand', :level => 359, :class => 'Hunter').to(2.00) }
  it { should price_item(:slot => 'Two-Hand', :level => 372, :class => 'Warrior').to(3.00) }
  it { should price_item(:slot => 'Two-Hand', :level => 359, :class => 'Warrior').to(2.50) }

  # Healer/Caster Weapons used in the Main Hand
  it { should price_item(:slot => 'Main Hand', :level => 372).to(4.00) }
  it { should price_item(:slot => 'Main Hand', :level => 359).to(3.50) }

  # Healer/Caster Shields/Held In Off Hand Items
  it { should price_item(:slot => 'Shield',           :level => 359).to(1.50) }
  it { should price_item(:slot => 'Shield',           :level => 372).to(2.00) }
  it { should price_item(:slot => 'Held in Off-Hand', :level => 372).to(2.00) }
  it { should price_item(:slot => 'Held in Off-Hand', :level => 359).to(1.50) }

  # Melee DPS/Hunter Weapons used in the Main Hand or Off Hand/Warrior Shields
  it { should price_item(:slot => 'Main Hand', :level => 372, :class => 'Death Knight').to(3.00) }
  it { should price_item(:slot => 'Main Hand', :level => 359, :class => 'Death Knight').to(2.50) }
  it { should price_item(:slot => 'Main Hand', :level => 372, :class => 'Hunter').to(1.25) }
  it { should price_item(:slot => 'Main Hand', :level => 359, :class => 'Hunter').to(1.00) }
  it { should price_item(:slot => 'One-Hand',  :level => 372, :class => 'Rogue').to(3.00) }
  it { should price_item(:slot => 'One-Hand',  :level => 359, :class => 'Rogue').to(2.50) }
  it { should price_item(:slot => 'Shield',    :level => 372, :class => 'Warrior').to(3.00) }
  it { should price_item(:slot => 'Shield',    :level => 359, :class => 'Warrior').to(2.50) }

  # Range/Relic Slot Items
  %w(relic idol totem thrown sigil ranged).each do |slot|
    it { should price_item(:slot => slot, :level => 372).to(1.50) }
    it { should price_item(:slot => slot, :level => 359).to(1.00) }
  end
  it { should price_item(:slot => 'Ranged', :level => 372, :class => 'Hunter').to(5.00) }
  it { should price_item(:slot => 'Ranged', :level => 359, :class => 'Hunter').to(4.00) }

  # Tokens
  it { should price_item(:name => 'Chest of the Forlorn Conqueror',     :level => 85).to(3.00) }
  it { should price_item(:name => 'Crown of the Forlorn Conqueror',     :level => 85).to(3.00) }
  it { should price_item(:name => 'Gauntlets of the Forlorn Conqueror', :level => 85).to(2.50) }
  it { should price_item(:name => 'Helm of the Forlorn Conqueror',      :level => 85).to(2.50) }
  it { should price_item(:name => 'Leggings of the Forlorn Conqueror',  :level => 85).to(3.00) }
  it { should price_item(:name => 'Mantle of the Forlorn Conqueror',    :level => 85).to(2.00) }
  it { should price_item(:name => 'Shoulders of the Forlorn Conqueror', :level => 85).to(2.50) }

  # Trinkets
  it { should price_item(:level => 372, :slot => 'Trinket').to(4.00) }
  it { should price_item(:level => 359, :slot => 'Trinket').to(4.00) }
end
