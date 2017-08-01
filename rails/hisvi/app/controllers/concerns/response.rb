module Response
  def json_response messages, data, status = :success
    render json: {
      messages: messages,
      data: data
    }, status: status
  end
end
