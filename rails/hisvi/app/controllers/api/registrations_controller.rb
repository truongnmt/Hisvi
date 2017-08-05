class Api::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :null_session

  def create
    user = User.new user_params

    if user.save
      messages = I18n.t "api.en.registrations.signed_up"
      json_response messages, user: user
    else
      messages = user.error.messages
      json_response messages, {}, :failure
    end
  end

  private
  
  def user_params
    params.require(:user).permit User::ATTRIBUTES_PARAMS
  end
end
