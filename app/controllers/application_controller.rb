class ApplicationController < ActionController::Base
rescue_from StandardError, with: :handle_exception

def handle_errors(messages, status, exception = nil)
  Rails.logger.error exception&.message
  render json: {error_messages: messages}.to_json, status: status
end

protected
  def handle_exception(exception)
    puts exception
    case exception
      when ::ActiveRecord::RecordNotFound
        handle_errors(["Record not found"], 404, exception)
        return
      when ::ActionController::RoutingError
        handle_errors(["route not found"], 404, exception)
        return
      else
        handle_errors(["Something went wrong, please try again later"], 500, exception)
        return
      end
    return
  end
end
