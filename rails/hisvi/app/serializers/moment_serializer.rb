class MomentSerializer < ActiveModel::Serializer
  include ActionView::Helpers::UrlHelper

  attributes :id, :story_id, :content, :is_completed

  belongs_to :story, if: ->{is_in_white_list?(:story)}

  def story
    {
      id: object.story.id,
      category_id: object.story.category_id,
      title: object.story.title,
      is_public: object.story.is_public
    }
  end

  def is_in_white_list? attr
    white_list = @instance_options[:white_list]

    return true unless white_list
    white_list.include? attr
  end

  def attributes *args
    white_list_attributes = @instance_options[:white_list]

    return super unless !!white_list_attributes
    filtered = super
    super.each do |attr|
      filtered = filtered.except(attr[0]) unless
        white_list_attributes.include? attr[0]
    end
    filtered
  end
end
