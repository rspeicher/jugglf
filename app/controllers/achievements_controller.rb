class AchievementsController < ApplicationController
  caches_action :index, :layout => false # NOTE: Gets 'expired' (deleted) by achievements.rake

  def index
    @achievements = Achievement.where(:category_id => 168).order(:title)
    @members = Member.active.order(:name).includes(:achievements)

    respond_to do |wants|
      wants.html
    end
  end
end
