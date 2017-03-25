class StaticPagesController < ApplicationController

  def home
    if logged_in?
  	  @note = current_user.notes.build
  	  @feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

  def about
  end

  def contact
  	
  end
end
