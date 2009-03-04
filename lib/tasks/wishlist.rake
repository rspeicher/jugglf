namespace :jugg do
  def boss(zone, name)
    return if zone.nil? or name.nil? or name.empty?
    zone.children.create(:boss => Boss.create(:name => name))
  end
  
  def item(boss, name)
    return if boss.nil? or name.nil? or name.empty?
    boss.children.create(:item => Item.find_or_create_by_name(name))
  end
  
  desc "Populate wishlist data"
  task :wishlist => [:environment] do
    [Boss, LootTable, Zone].each(&:destroy_all)
    
    # Naxxramas ---------------------------------------------------------------
    ['Naxxramas (H)'].each do |zone_name|
      zone = LootTable.create(:zone => Zone.create(:name => zone_name))
      
      [ 'Trash', 'Anub\'Rekhan', 'Grand Widow Faerlina', 'Maexxna', 
        'Noth the Plaguebringer', 'Heigan the Unclean', 'Loatheb', 'Patchwerk',
        'Grobbulus', 'Gluth', 'Thaddius', 'Instructor Razuvious', 
        'Gothik the Harvester', 'Four Horsemen', 'Sapphiron', 
        'Kel\'Thuzad'].each do |boss_name|
          boss = boss(zone, boss_name)
          
          case boss_name
          when 'Trash'
            item(boss, "Boots of the Escaped Captive")
            item(boss, "Haunting Call")
            item(boss, "Inevitable Defeat")
            item(boss, "Ousted Bead Necklace")
            item(boss, "Shadow of the Ghoul")
            item(boss, "Shoulderguards of the Undaunted")
            item(boss, "Silent Crusader")
          when 'Anub\'Rekhan'
            item(boss, "Arachnoid Gold Band")
            item(boss, "Chains of Adoration")
            item(boss, "Corpse Scarab Handguards")
            item(boss, "Cryptfiend's Bite")
            item(boss, "Dawnwalkers")
            item(boss, "Gemmed Wand of the Nerubians")
            item(boss, "Inexorable Sabatons")
            item(boss, "Leggings of Atrophy")
            item(boss, "Mantle of the Locusts")
            item(boss, "Pauldrons of Unnatural Death")
            item(boss, "Rescinding Grips")
            item(boss, "Ruthlessness")
            item(boss, "Sabatons of Sudden Reprisal")
            item(boss, "Sand-Worn Band")
            item(boss, "Sash of the Parlor")
            item(boss, "Shield of Assimilation")
            item(boss, "Strong-Handed Ring")
            item(boss, "Swarm Bindings")
            item(boss, "Thunderstorm Amulet")
          when 'Grand Widow Faerlina'
          when 'Maexxna'
          when 'Noth the Plaguebringer'
          when 'Heigan the Unclean'
          when 'Loatheb'
          when 'Patchwerk'
          when 'Grobbulus'
          when 'Gluth'
          when 'Thaddius'
          when 'Instructor Razuvious'
          when 'Gothik the Harvester'
          when 'Four Horsemen'
          when 'Sapphiron'
          when 'Kel\'Thuzad'
            item(boss, "Betrayer of Humanity")
            item(boss, "Boundless Ambition")
            item(boss, "Calamity's Grasp")
            item(boss, "Cape of the Unworthy Wizard")
            item(boss, "Crown of the Lost Conqueror")
            item(boss, "Crown of the Lost Protector")
            item(boss, "Crown of the Lost Vanquisher")
            item(boss, "Drape of the Deadly Foe")
            item(boss, "Envoy of Mortality")
            item(boss, "Journey's End")
            item(boss, "Last Laugh")
            item(boss, "Leggings of Mortal Arrogance")
            item(boss, "Signet of Manifested Pain")
            item(boss, "Sinister Revenge")
            item(boss, "The Turning Tide")
            item(boss, "Torch of Holy Fire")
            item(boss, "Voice of Reason")
            item(boss, "Wall of Terror")
          end
        end
    end
  end
end