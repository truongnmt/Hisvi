class Api::BaseController < ApplicationController
  include Authenticable
  include Response
  include SerializableResource

  acts_as_token_authentication_handler_for User, fallback: :none

  private

  alias authentication_user_from_token authenticate_with_token!

  def find_varible_name
    return if params_controller.blank?
    params_controller.split("/").last.singularize
  end

  def ensure_parameters_exist
    find_varible_name

    return if params[find_varible_name].present?
    messages = I18n.t("api.missing_params")
    json_response messages, {}, :bad_request
  end

  def find_object
    instance_name = find_varible_name
    instance_variable_set "@#{instance_name}",
      instance_name.classify.constantize.find_by(id: params[:id])
    messages = I18n.t("#{instance_name.pluralize}.messages.#{instance_name}_not_found")
    json_response messages, {}, :not_found unless instance_variable_get "@#{instance_name}"
  end

  def correct_user object
    object.eql? current_user
  end

  def params_controller
    params[:controller]
  end

  def invalid_permission
    render json: {
      messages: I18n.t("api.invalid_permission")
    }, status: :unauthorized
  end
end
