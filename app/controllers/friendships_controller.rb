class FriendshipsController < ApplicationController
  before_action :logged_in_user,   only: [:show, :update, :create, :index, :search, :confirm]

  def index
    @friends = current_user.friends
    @user = current_user

    @friendship_requests = Friendship.where(confirmed: false, accepted: true, user_id: @user.id)

    if params[:search].present?
      @search_friend = User.find_by(name: params[:search].downcase)
      @search_friend = User.find_by(email: params[:search].downcase) if !@search_friend.present?
      if @search_friend.present?
        @friendship_request = Friendship.find_by(user_id: @user.id, friend_id: @search_friend.id)
        if !@friendship_request.present?
          @friendship = Friendship.new(user_id: @user.id, friend_id: @search_friend.id)
        end
      end
    end
  end

  def create
    @friendship = Friendship.create_bidirectional_friendship(current_user.id, friendship_params["friend_id"])
    if @friendship
      flash[:success] = "Request sent!"
      redirect_to friendships_path
    else
      @friendship.errors.full_messages.each do |error|
        flash[:danger] = error
      end
      redirect_to friendships_path, search: params[:search]
    end
  end

  def confirm
    @friendship = Friendship.find(params[:id])
    if params[:commit] == "CONFIRM"
      flash[:success] = "You are now friends!"
      @friendship.accept_friendship
    elsif params[:commit] == "DENY"
      flash[:success] = "Friendship request denied"
      @friendship.reject_friendship
    end
  end

  # def add_friend
  #   if !params[:friend_name].present?
  #     render json: { error: 'bad request 1' }, status: 400 and return
  #   end
  #   if @user.add_friend(params[:friend_name])
  #     render json: { status: 'success' }, status: 201 and return
  #   else
  #     render json: { error: "Could not add #{params[:friend_name]}" }, status: 400 and return
  #   end
  # end

  # def confirm_friendship
  #   if !params[:friend_id].present? || !params[:accept].present?
  #     render json: { error: 'bad request 1' }, status: 400 and return
  #   end

  #   friendship = Friendship.find_by(user_id: @user.id, friend_id: params[:friend_id].to_i, confirmed: false)
  #   if !friendship.present?
  #     render json: { error: 'Friendship request not found' }, status: 400 and return
  #   end

  #   if params[:accept].to_i == 1 && friendship.accept_friendship
  #     render json: { status: 'Friend added' }, status: 201 and return
  #   elsif friendship.reject_friendship
  #     render json: { status: 'Friend rejected' }, status: 201 and return
  #   else
  #     render json: { status: 'Error' }, status: 400 and return
  #   end
  # end

  # def friends
  #   render json: { friends: @user.friend_names_and_ids, requests: @user.client_friendship_requests }, status: 201 and return
  # end

  # def show_friend
  #   friend = User.find(params[:friend_id].to_i)
  #   if friend.present?
  #     render json: Api::V2::FriendSerializer.new(friend.block_game_profile).to_json, status: 201
  #   else
  #     render json: { status: 'Error' }, status: 400 and return
  #   end
  # end

  private

    def friendship_params
      params.require(:friendship).permit(:friend_id)
    end

end