class StoriesController < ApplicationController
  before_action :logged_in_user,   only: [:update, :create]
  before_action :is_friend,     only: [:update, :create]

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      flash[:success] = "Comment updated."
      redirect_to @story
    else
      render @story
    end
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to @story
    else
      @topic = current_user.next_topic
      render @story
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:story_id, :visibility, :user_id, :text)
  end

  def is_friend
    @story.find(params[:story_id])
    author = @story.user
    @user = @user || User.find_by(name: params[:id].downcase)
    if @user != current_user && !Friendship.exists?(user_id: current_user.id, friend_id: @author.id, accepted: true)
      flash[:danger] = "Must be friends to do that."
      redirect_to(root_url)
    end
  end
end
