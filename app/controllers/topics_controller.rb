class TopicsController < ApplicationController
  before_action :admin_user, only: [:create, :destroy, :new, :edit, :update, :index]

  def new
    @topic = Topic.new
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update(topic_params)
      flash[:success] = "Topic updated!"
      redirect_to @topic
    else
      render 'edit'
    end
  end

  def destroy
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:success] = "Topic created!"
      redirect_to topics_path
    else
      redirect_to @topic
    end
  end

  def show
    topic_id = params[:id]
    @topic = Topic.find(topic_id)
  end

  def index
    @topics = Topic.all
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :content)
  end

end
