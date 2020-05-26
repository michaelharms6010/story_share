class NotificationsController < ApplicationController
  before_action :logged_in_user,   only: [:index]

  def index
    @notifications = current_user.unread_notifications
  end

end
