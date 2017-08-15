class Api::V1::LikeController < Api::BaseController
  def create
    like_record = Like.new
    like_record.user_id = params[:user_id]
    like_record.story_id = params[:story_id]

    if like_record.save
      json_response I18n.t("like.create.success"), {}, :ok
    else
      json_response I18n.t("like.create.fail"), {}, :unprocessable_entity
    end
  end

  def destroy
    liked_record = Like.find_by user_id: params[:user_id], story_id: params[:story_id]

    if liked_record && liked_record.destroy
      json_response I18n.t("like.destroy.success"), {}, :ok
    else
      json_response I18n.t("like.destroy.fail"), {}, :unprocessable_entity
    end
  end
end
