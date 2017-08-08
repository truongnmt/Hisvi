class Api::V1::UsersController < Api::BaseController
  before_action :find_object, only: %i(show update destroy)

  attr_reader :user, :users

  def index
    @users = User.all
    json_response I18n.t("users.index.success"), {user: users}, :ok
  end

  def show
    json_response I18n.t("users.show.success"), {user: user}, :ok
  end

  def update
    if correct_user user
      if user.update_attributes user_params
        updated_successfully
      else
        updated_fail
      end
    else
      invalid_permission
    end
  end

  def destroy
    if correct_user user
      user.destroy ? destroy_success : destroy_fail
    else
      invalid_permission
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :encrypted_password,
      :reset_password_token, :reset_password_sent_at, :remember_created_at,
      :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip,
      :last_sign_in_ip, :created_at, :updated_at, :bio, :is_admin,
      :authentication_token, :username
  end

  def updated_successfully
    json_response I18n.t("users.update.success"), {user: user}, :ok
  end

  def updated_fail
    json_response I18n.t("users.update.fail"), {}, :unprocessable_entity
  end

  def destroy_success
    json_response I18n.t("users.destroy.success"), {}, :ok
  end

  def destroy_fail
    json_response I18n.t("users.destroy.fail"), {}, :unprocessable_entity
  end
end
