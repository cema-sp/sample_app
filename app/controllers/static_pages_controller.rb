class StaticPagesController < ApplicationController
  def home
    # @feed_items = nil
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.
        paginate(page: params[:page], per_page: 20)
    end
  end

  def help
  end

  def about
  end

  def contacts
  end
end
