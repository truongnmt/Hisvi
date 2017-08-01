class Api::BaseController < ApplicationController::API
  include Authenticable
  include Response

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
    json_response messages, {}, :failure
  end

  def find_object
    instance_name = find_varible_name
    instance_variable_set "@#{instance_name}",
      instance_name.classify.constantize.find_by(id: params[:id])
    messages = I18n.t("#{instance_name.pluralize}.messages.#{instance_name}_not_found")
    json_response messages, {}, :failure unless instance_variable_get "@#{instance_name}"
  end

  def params_controller
    params[:controller]
  end
end
