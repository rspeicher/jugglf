require 'spec_helper'

describe ItemPrice do
  include PriceItemMatcher

  subject { ItemPrice.instance }

  it "should validate keys" do
    expect { subject.price(:invalid => 'Something', :id => 12345) }.to raise_error(ArgumentError)
  end

  # Head/Chest/Legs Slot Items
  it { should price_item(:slot => 'Head',  :level => 391).to(3.00) }
  it { should price_item(:slot => 'Head',  :level => 378).to(2.50) }
  it { should price_item(:slot => 'Chest', :level => 391).to(3.00) }
  it { should price_item(:slot => 'Chest', :level => 378).to(2.50) }
  it { should price_item(:slot => 'Legs',  :level => 391).to(3.00) }
  it { should price_item(:slot => 'Legs',  :level => 378).to(2.50) }

  # Shoulder/Hands/Feet Slot Items
  it { should price_item(:slot => 'Shoulder', :level => 391).to(2.50) }
  it { should price_item(:slot => 'Shoulder', :level => 378).to(2.00) }
  it { should price_item(:slot => 'Hands',    :level => 391).to(2.50) }
  it { should price_item(:slot => 'Hands',    :level => 378).to(2.00) }
  it { should price_item(:slot => 'Feet',     :level => 391).to(2.50) }
  it { should price_item(:slot => 'Feet',     :level => 378).to(2.00) }

  # Wrists/Waist/Finger Slot Items
  it { should price_item(:slot => 'Wrist',  :level => 391).to(2.00) }
  it { should price_item(:slot => 'Wrist',  :level => 378).to(1.50) }
  it { should price_item(:slot => 'Waist',  :level => 391).to(2.00) }
  it { should price_item(:slot => 'Waist',  :level => 378).to(1.50) }
  it { should price_item(:slot => 'Finger', :level => 391).to(2.00) }
  it { should price_item(:slot => 'Finger', :level => 378).to(1.50) }

  # Neck/Back Slot Items
  it { should price_item(:slot => 'Neck', :level => 391).to(2.00) }
  it { should price_item(:slot => 'Neck', :level => 378).to(1.50) }
  it { should price_item(:slot => 'Back', :level => 391).to(2.00) }
  it { should price_item(:slot => 'Back', :level => 378).to(1.50) }

  # Two-Hand Weapons
  it { should price_item(:slot => 'Two-Hand', :level => 391).to(6.00) }
  it { should price_item(:slot => 'Two-Hand', :level => 378).to(5.00) }
  it { should price_item(:slot => 'Two-Hand', :level => 391, :class => 'Hunter').to(2.50) }
  it { should price_item(:slot => 'Two-Hand', :level => 378, :class => 'Hunter').to(2.00) }

  # Healer/Caster Weapons used in the Main Hand
  it { should price_item(:slot => 'Main Hand', :level => 391).to(4.00) }
  it { should price_item(:slot => 'Main Hand', :level => 378).to(3.50) }

  # Healer/Caster Shields/Held In Off Hand Items
  it { should price_item(:slot => 'Shield',           :level => 378).to(1.50) }
  it { should price_item(:slot => 'Shield',           :level => 391).to(2.00) }
  it { should price_item(:slot => 'Held in Off-Hand', :level => 391).to(2.00) }
  it { should price_item(:slot => 'Held in Off-Hand', :level => 378).to(1.50) }

  # Melee DPS/Hunter Weapons used in the Main Hand or Off Hand/Warrior Shields
  it { should price_item(:slot => 'Main Hand', :level => 391, :class => 'Death Knight').to(3.00) }
  it { should price_item(:slot => 'Main Hand', :level => 378, :class => 'Death Knight').to(2.50) }
  it { should price_item(:slot => 'Main Hand', :level => 391, :class => 'Hunter').to(1.25) }
  it { should price_item(:slot => 'Main Hand', :level => 378, :class => 'Hunter').to(1.00) }
  it { should price_item(:slot => 'One-Hand',  :level => 391, :class => 'Rogue').to(3.00) }
  it { should price_item(:slot => 'One-Hand',  :level => 378, :class => 'Rogue').to(2.50) }
  it { should price_item(:slot => 'Shield',    :level => 391, :class => 'Warrior').to(3.00) }
  it { should price_item(:slot => 'Shield',    :level => 378, :class => 'Warrior').to(2.50) }

  # Range/Relic Slot Items
  %w(relic idol totem thrown sigil ranged).each do |slot|
    it { should price_item(:slot => slot, :level => 391).to(1.50) }
    it { should price_item(:slot => slot, :level => 378).to(1.00) }
  end
  it { should price_item(:slot => 'Ranged', :level => 391, :class => 'Hunter').to(5.00) }
  it { should price_item(:slot => 'Ranged', :level => 378, :class => 'Hunter').to(4.00) }

  # Tokens
  it { should price_item(:name => 'Chest of the Fiery Conqueror',     :level => 391).to(3.00) }
  it { should price_item(:name => 'Crown of the Fiery Conqueror',     :level => 391).to(3.00) }
  it { should price_item(:name => 'Gauntlets of the Fiery Conqueror', :level => 391).to(2.50) }
  it { should price_item(:name => 'Leggings of the Fiery Conqueror',  :level => 391).to(3.00) }
  it { should price_item(:name => 'Shoulders of the Fiery Conqueror', :level => 391).to(2.50) }
  it { should price_item(:name => 'Helm of the Fiery Conqueror',      :level => 378).to(2.50) }
  it { should price_item(:name => 'Mantle of the Fiery Conqueror',    :level => 378).to(2.00) }

  # Trinkets
  it { should price_item(:level => 391, :slot => 'Trinket').to(4.00) }
  it { should price_item(:level => 378, :slot => 'Trinket').to(4.00) }
end
