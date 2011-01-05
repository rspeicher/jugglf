module WishlistData
  module Cataclysm
    class ThroneOfFourWinds
      include WishlistData

      active_difficulties :normal_25, :heroic_25

      difficulty :normal_25 do
        boss "Conclave of Wind" do
          item 63497 #Gale Rouser Belt
          item 63496 #Lightning Well Belt
          item 63488 #Mistral Circle
          item 63489 #Permafrost Signet
          item 63494 #Planetary Band
          item 63490 #Sky Strider Belt
          item 63498 #Soul Breath Belt
          item 63492 #Star Chaser Belt
          item 63495 #Tempest Keeper Belt
          item 63491 #Thunder Wall Belt
          item 63493 #Wind Stalker Belt
        end

        boss "Al'akir" do
          item 63499 #Cloudburst Ring
          item 63506 #Gale Rouser Leggings
          item 63505 #Lightning Well Legguards
          item 63041 #Reins of the Drake of the South Wind
          item 63500 #Sky Strider Greaves
          item 63507 #Soul Breath Leggings
          item 68127 #Stormwake the Tempest's Reach
          item 68129 #Stormwake the Tempest's Reach
          item 63504 #Tempest Keeper Leggings
          item 63501 #Thunder Wall Greaves
        end
      end

      difficulty :heroic_25 do
        boss "Conclave of Wind" do
          item 65374 #Gale Rouser Belt
          item 65377 #Lightning Well Belt
          item 65367 #Mistral Circle
          item 65372 #Permafrost Signet
          item 65373 #Planetary Band
          item 65369 #Sky Strider Belt
          item 65376 #Soul Breath Belt
          item 65368 #Star Chaser Belt
          item 65375 #Tempest Keeper Belt
          item 65370 #Thunder Wall Belt
          item 65371 #Wind Stalker Belt
        end

        boss "Al'akir" do
          item 65382 #Cloudburst Ring
          item 65384 #Gale Rouser Leggings
          item 65386 #Lightning Well Legguards
          item 63041 #Reins of the Drake of the South Wind
          item 65379 #Sky Strider Greaves
          item 65383 #Soul Breath Leggings
          item 68132 #Stormwake the Tempest's Reach
          item 68131 #Stormwake the Tempest's Reach
          item 68130 #Stormwake the Tempest's Reach
          item 65385 #Tempest Keeper Leggings
          item 65380 #Thunder Wall Greaves
        end
      end
    end
  end
end
