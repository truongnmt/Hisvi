module Authenticable
  def current_user
    auth_token = request.headers["MS-AUTH-TOKEN"]

    return unless auth_token
    @current_user ||= User.find_by authentication_token: auth_token
  end

  def authenticate_with_token!
    return if current_user
    render json: {
      messages: I18n.t("devise.failure.unauthenticated")
    }, status: :failure
  end

  def user_signed_in?
    current_user.present?
  end
end
