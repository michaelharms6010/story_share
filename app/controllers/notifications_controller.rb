class CommentsController < ApplicationController
  before_action :logged_in_user,   only: [:index]

  def index
    notification = current_user.unread_notifications
  end

end
