class CommentsController < ApplicationController
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
    @story = @comment.story
    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to @story
    else
      render "stories/show", story: @story, detail: true
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:story_id, :visibility, :user_id, :text)
  end

  def is_friend
    @story = Story.find(params[:comment][:story_id])
    author = @story.user
    if author != current_user && current_user.friends?(author)
      flash[:danger] = "Must be friends to do that."
      redirect_to(root_url)
    end
  end
end
