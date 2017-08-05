class Api::RegistrationsController < Devise::RegistrationsController
  # protect_from_forgery with: :null_session

  before_action :ensure_params_exist, only: :create

  def create
    user = User.new user_params

    if user.save
      messages = I18n.t "devise.registrations.signed_up"
      json_response messages, {user: user}, :created
    else
      messages = user.errors.full_messages
      json_response messages, {}, :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :encrypted_password,
      :reset_password_token, :reset_password_sent_at, :remember_created_at,
      :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip,
      :last_sign_in_ip, :created_at, :updated_at, :bio, :is_admin,
      :authentication_token, :username, :password, :password_confirmation
  end

  def ensure_params_exist
    return if params[:user].present?

    messages = I18n.t "api.missing_params"
    json_response messages, {}, :bad_request
  end
end
