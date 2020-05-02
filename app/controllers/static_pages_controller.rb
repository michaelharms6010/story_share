class StaticPagesController < ApplicationController

  def home
    @user = current_user
    if @user.present? && !@user.profile_completed
      redirect_to profile_edit_path
    elsif @user.present?
      @stories = @user.all_stories.page(params[:page]).per(10)
    end
  end
end
