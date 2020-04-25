class StaticPagesController < ApplicationController

  def home
    @user = current_user
    if @user.present?
      @stories = @user.all_stories
    end
  end
end
