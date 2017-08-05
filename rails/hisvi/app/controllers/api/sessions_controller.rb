class Api::SessionsController < Devise::SessionsController
  include Response

  skip_before_action :verify_signed_out_user, only: :destroy

  before_action :ensure_params_exist, :load_user, only: :create
  before_action :valid_token, only: :destroy

  def create
    if user.valid_password? sign_in_params[:password]
      sign_in "user", user
      messages = I18n.t "sessions.signed_in"
      data = {user: user}
      json_response messages, data
    else
      invalid_login_attempt
    end
  end

  def destroy
    sign_out user
    user.generate_new_authentication_token
    messages = I18n.t "sessions.signed_out"
    json_response messages, {}
  end

  private

  def sign_in_params
    params.require(:sign_in).permit :email, :password
  end

  def ensure_params_exist
    return if params[:sign_in].present?
    messages = I18n.t "api.missing_params"
    json_response messages, {}, :failure
  end

  def invalid_login_attempt
    messages = I18n.t "devise.failure.invalid", authentication_keys: "email"
    json_response messages, {}, :failure
  end

  def load_user
    @user = User.find_for_database_authentication email: sign_in_params[:email]

    return if user
    messages = I18n.t "devise.failure.invalid", authentication_keys: "email"
    json_response messages, {}, :failure
  end

  def valid_token
    @user =
      User.find_by authentication_token: request.headers["MS-AUTH-TOKEN"]

    return if user
    messages = I18n.t "api.invalid_token"
    json_response messages, {}, :failure
  end
end
