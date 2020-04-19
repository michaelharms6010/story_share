class StoriesController < ApplicationController
  before_action :logged_in_user,   only: [:show, :edit, :update, :create, :index, :new]
  before_action :correct_user,     only: [:show, :edit, :update, :create, :index]

  def new
    @story = Story.new
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
    @story.published=true
    @story.published_at=Time.now
    if @story.save
      flash[:success] = "Story created!"
      redirect_to stories_path
    else
      redirect_to stories_path
    end
  end

  def show
    story_id = params[:id]
    @story = Story.find(story_id)
  end

  def index
    @stories = Story.where(published: true).order("published_at DESC").paginate(page: params[:page], :per_page => 5)
  end

  private

  def story_params
    params.require(:story).permit(:title, :content)
  end

end
