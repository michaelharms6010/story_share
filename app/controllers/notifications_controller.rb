class CommentsController < ApplicationController
  before_action :logged_in_user,   only: [:index]

  # def index
  #   notification = 
  # end

end
