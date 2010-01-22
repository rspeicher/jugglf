class AchievementsController < ApplicationController
  caches_action :index, :layout => false # NOTE: Gets 'expired' (deleted) by achievements.rake

  def index
    page_title('Achievements')

    ignored = [
      3010, # Drive Me Crazy
      2928, # Hot Pocket
      2965, # I Have the Coolest Friends
      2974, # I'll Take You All On
      3011, # Kiss and Make Up
      3185, # Knock on Wood
      3186, # Knock, Knock on Wood
      2936, # Nerf Gravity Bombs
      2918, # Orbital Bombardment
      2916, # Orbital Devastation
      2917, # Nuked from Orbit
      2978, # Siffed
      2970, # Staying Buffed All Winter
      2889, # The Antechamber of Ulduar
      2893, # The Descent into Madness
      2891, # The Keepers of Ulduar
      2895, # The Secrets of Ulduar
      2887, # The Siege of Ulduar
      3161, # Three Lights in the Darkness
      3162, # Two Lights in the Darkness
      2976, # Who Needs Bloodlust?
    ]

    @achievements = Achievement.find(:all, :order => 'title',
      :conditions => ["category_id = ? AND armory_id NOT IN (#{ignored.join(',')})", 168])
    @members = Member.active.find(:all, :include => :achievements)

    respond_to do |wants|
      wants.html
    end
  end
end
