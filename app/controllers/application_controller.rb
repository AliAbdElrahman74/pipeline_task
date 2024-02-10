class ApplicationController < ActionController::Base
rescue_from StandardError, with: :handle_exception

protected
  def handle_exception(exception)
    puts exception
    case exception
      when ::ActiveRecord::RecordNotFound
        handle_error("Record not found", 404, exception)
        return
      when ::ActionController::RoutingError
        handle_error("route not found", 404, exception)
        return
      else
        handle_error("Something went wrong, please try again later", 500, exception)
        return
      end
    return
  end

  def handle_error(message, status, exception)
    Rails.logger.error exception.message
    render json: {error_message: message}.to_json, status: status
  end
end
