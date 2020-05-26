class NotificationsController < ApplicationController
  before_action :logged_in_user,   only: [:index, :show]

  def index
    @notifications = current_user.notifications.order("id DESC").page(params[:page])
  end

  def show
    @notification = Notification.find(params[:id])
    @notification.update(viewed: true) if !@notification.viewed
    redirect_to @notification.comment.story
  end

end
