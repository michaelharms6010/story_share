class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :destroy, :show, :invite, :create_invite, :profile]
  before_action :logged_in_profile_incomplete, only: [:edit_profile, :update]
  before_action :is_friend,      only: [:show]
  before_action :admin_user,     only: :destroy

  def new
    @user = User.new
  end

  def invite
    @invite = {email: "", message: ""}
    @user = User.new
  end

  def profile
    @user = current_user
    render "show"
  end

  def create
    @user = User.new(user_params)
    @user.profile_completed = @user.name.present? && params[:user][:password].present?
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def create_invite
    @invite = {email: params[:email], message: params[:message], invited_by: current_user.id}
    random_password = SecureRandom.urlsafe_base64
    @user = User.new(password: random_password, password_confirmation: random_password,
                    email: @invite[:email], profile_completed: false)
    if @user.save
      @user.send_invite_email(current_user, params[:message])
      flash[:info] = "Invite sent!"
      redirect_to root_url
    else
      render 'invite'
    end
  end

  def edit_profile
    @user = current_user
  end

  def update
    @user = current_user
    if !@user.profile_completed
      @user.update(user_params)
      @user.errors.add(:password, "must be updated") if params[:user][:password].blank?
      if @user.errors.present?
        render "edit_profile"
      else
        @user.update(profile_completed: true)
        Friendship.create_and_confirm_bidirectional_friendship(@user.id, @user.invited_by) if @user.invited_by.present?
        flash[:success] = "Profile updated"
        redirect_to root_url
      end
    elsif @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to profile_path
    else
      render 'edit_profile'
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
