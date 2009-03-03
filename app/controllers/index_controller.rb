class IndexController < ApplicationController
  layout @@layout
  
  def index
    respond_to do |wants|
      wants.html
    end
  end
end
