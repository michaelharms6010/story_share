class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :show, :invite, :create_invite]
  before_action :correct_user,   only: [:update]
  before_action :is_friend,      only: [:show]
  before_action :admin_user,     only: :destroy

  def new
    @user = User.new
  end

  def invite
    @invite = {first_name: "", last_name: "", email: "", message: ""}
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def create_invite
    @invite = {first_name: params[:first_name], last_name: params[:last_name], email: params[:email], message: params[:message]}
    random_name = (0...12).map { (65 + rand(26)).chr }.join
    random_password = SecureRandom.urlsafe_base64
    @user = User.new(name: random_name, password: random_password, password_confirmation: random_password,
                    email: @invite[:email], first_name: @invite[:first_name], last_name: @invite[:last_name],
                    is_guest: true)
    if @user.save
      @user.send_invite_email(current_user, params[:message])
      flash[:info] = "Invite sent!"
      redirect_to root_url
    else
      render 'invite'
    end
  end

  def edit
    @user = current_user
    @user.name = "" if @current_user.is_guest
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to "/users/#{@user.name}"
    else
      render 'edit'
    end
  end

  def show
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,
                                   :first_name, :last_name,
                                   :show_full_name,
                                   :time_zone)
    end

    # Confirms the correct user.
    def correct_user
      redirect_to(root_url) unless current_user?(User.find(params[:id]))
    end

    def is_friend
      @user = @user || User.find_by(name: params[:id].downcase)
      if @user != current_user && !Friendship.exists?(user_id: current_user.id, friend_id: @user.id, accepted: true)
        flash[:danger] = "Must be friends to view profile."
        redirect_to(root_url)
      end
    end


end
