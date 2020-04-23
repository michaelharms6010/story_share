class StaticPagesController < ApplicationController

  before_action :logged_in_user,   only: [:home]

  def home
    @user = current_user
    @stories = @user.all_stories
  end
end
