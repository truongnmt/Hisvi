class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :image, :is_public

  belongs_to :category, if: ->{is_in_white_list?(:category)}
  belongs_to :user, if: ->{is_in_white_list?(:user)}
  has_many :moments, if: ->{is_in_white_list?(:moments)}

  def image
    object.image_url
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
