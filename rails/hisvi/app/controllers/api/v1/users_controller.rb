class Api::V1::UsersController < Api::BaseController
  before_action :find_object, only: :show

  def show
    messages = I18n.t "messages.not_found", model_name: User
    data = {}
    json_response messages, data
  end
end
