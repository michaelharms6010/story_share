class StoriesController < ApplicationController
  before_action :logged_in_user,   only: [:show, :edit, :update, :create, :index, :new]
  before_action :correct_user,     only: [:show, :edit, :update]

  def new
    @story = Story.new
    @topic = current_user.next_topic if current_user.story_available
  end

  def edit
    @story = Story.find(params[:id])
  end

  def update
    @story = Story.find(params[:id])
    if @story.update(story_params)
      flash[:success] = "Story updated!"
      redirect_to @story
    else
      render 'edit'
    end
  end

  def destroy
  end

  def create
    @story = Story.new(story_params)
    @story[:user_id] = current_user.id
    if @story.save
      flash[:success] = "Story created!"
      redirect_to stories_path
    else
      @topic = current_user.next_topic
      render 'new'
    end
  end

  def show
    story_id = params[:id]
    @story = Story.find(story_id)
  end

  def index
    @topics = Topic.where(id: current_user.stories.select(:topic_id)).page(params[:page]).order("id DESC")
  end

  private

  def story_params
    params.require(:story).permit(:text, :word_count, :visibility, :topic_id)
  end


  def correct_user
    @story = Story.find(params[:id])
    redirect_to(root_url) unless current_user?(@story.user)
  end

end
