class Api::V1::StoriesController < Api::BaseController
  before_action :find_object, only: %i(show update destroy)
  before_action :authenticate_with_token!, only: %i(create update destroy)

  attr_reader :story, :stories

  def index
    stories = Story.all
    white_list = [:id, :category, :title, :user, :is_public, :image]
    json_stories = parse_json stories, white_list
    json_response I18n.t("stories.index.success"), {stories: json_stories}
  end

  def create
    story = current_user.stories.build story_params
    if story.save
      message = I18n.t("stories.create.success")
    else
      message = I18n.t("stories.create.error")
    end
    json_response message, {story: story}, :created
  end

  def show
    if story
      json_response I18n.t("stories.show.success"), {story: story}, :ok
    else
      json_response I18n.t("stories.show.story_not_found"), {}, :falure
    end
  end

  def update
    story = current_user.stories.find_by id: params[:id]

    if story
      if story.update_attributes story_params
        json_response I18n.t("stories.update.success"), {story: story}, :ok
      else
        json_response I18n.t("stories.update.fail"), {}, :unprocessable_entity
      end
    else invalid_permission
    end
  end

  def destroy
    if story
      if story.destroy
        json_response I18n.t("stories.destroy.success"), {story: story}, :ok
      else
        json_response I18n.t("stories.destroy.fail"), {}, :unprocessable_entity
      end
    else
      invalid_permission
    end
  end

  private

  def story_params
    params.require(:story).permit :category_id, :title,
      :is_public, :image
  end

  def moments_params
    params.require(:moments).permit :content, :is_completed, :image
  end
end
