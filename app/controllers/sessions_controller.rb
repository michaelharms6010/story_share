class SessionsController < ApplicationController

  def create
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
    user_string = create_params[:name].downcase
    user = User.is_email(user_string) ? User.find_by(email: user_string) : User.find_by(name: user_string)
    if user.present? && params[:version].present? &&
       ((create_params[:password].present? && user.authenticate(create_params[:password])) ||
       (token.present? && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token) ))
      user.block_game_profile.update_flower
      render(
        json: Api::V2::SessionSerializer.new(user, root: false, version: params[:version]).to_json,
        status: 201
      )
    else
      render json: { error: 'Invalid Login' }, status: 400 and return
    end
  end

  private
  def create_params
    params.require(:user).permit(:name, :password)
  end

end
