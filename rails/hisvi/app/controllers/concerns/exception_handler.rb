module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |result|
      json_response({message: result.message}, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |result|
      json_response({message: result.message}, :unprocessable_entity)
    end
  end
end
