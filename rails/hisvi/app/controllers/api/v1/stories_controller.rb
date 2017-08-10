class Api::V1::StoriesController < Api::BaseController
  def index
    @stories = current_user.stories
    json_response I18n.t("stories.index.success"), {stories: @stories}, :ok
  end

  def create
    story = current_user.stories.build story_params
    moments = story.moments.build moments_params

    if moments.save
      if story.save
        message = I18n.t("stories.create.success")
      else
        message = I18n.t("stories.create.error")
      end
    else
      message = I18n.t("stories.create.error")
    end
    json_response message, {story: story}, :created
  end

  def show
    story = current_user.stories.find_by id: params[:id]

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
    story = current_user.stories.find_by id: params[:id]

    if story
      if story.destroy
        json_response I18n.t("stories.destroy.success"), {story: story}, :ok
      else
        json_response I18n.t("stories.destroy.fail"), {}, :unprocessable_entity
      end
    else invalid_permission
    end
  end

  private

  def story_params
    params.require(:story).permit :category_id, :title,
      :is_public
  end

  def moments_params
    params.require(:moments).permit :content, :is_completed
  end
end
