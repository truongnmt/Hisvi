module SerializableResource
  def parse_json object, white_list = nil
    ActiveModelSerializers::SerializableResource.new(object, white_list: white_list).as_json
  end
end
