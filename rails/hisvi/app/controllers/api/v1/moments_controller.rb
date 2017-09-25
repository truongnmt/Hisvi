class Api::V1::MomentsController < Api::BaseController
  before_action :find_object, only: %i(show update destroy)
  before_action :authenticate_with_token!, only: %i(create delete)
  before_action :correct_user_permission, only: %i(update destroy)

  attr_reader :moment, :moments

  def index
    @moments = Moment.all
    # white_list = %i(id story_id content story)
    json_moments = parse_json moments
    json_response I18n.t("moments.index.success"), {moment: json_moments}, :ok
  end

  def create
    moment = Moment.new moment_params
    moment.story_id = params[:story_id]
    if moment.save
      messages = I18n.t "moments.create.success"
      json_moment = parse_json moment
      json_response messages, {moment: json_moment}, :created
    else
      messages = moment.errors.messages
      json_response messages, {}, :unprocessable_entity
    end
  end

  def show
    json_response I18n.t("moments.show.success"), {moment: moment}, :ok
  end

  def update
    if moment.update_attributes moment_params
      updated_successfully
    else
      updated_fail
    end
  end

  def destroy
    moment.destroy ? destroy_success : destroy_fail
  end

  private

  def moment_params
    params.require(:moment).permit :content, :image, :is_completed
  end

  def updated_successfully
    json_response I18n.t("moments.update.success"), {result: true}, :ok
  end

  def updated_fail
    json_response I18n.t("moments.update.fail"), {result: false}, :unprocessable_entity
  end

  def destroy_success
    json_response I18n.t("moments.destroy.success"), {result: true}, :ok
  end

  def destroy_fail
    json_response I18n.t("moments.destroy.fail"), {result: false}, :unprocessable_entity
  end

  def correct_user_permission
    return invalid_permission unless correct_user User.find_by id:
      Story.find_by(id: moment.story_id).user_id
  end
end
