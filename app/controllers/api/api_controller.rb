# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    def render_status(status, message)
      ApiRequest.create!(request_method: request.request_method, controller_class: request.controller_class,
                         path: request.path, status: status, message: message)
      render json: { message: message }, status: status
    end

    rescue_from ActiveRecord::RecordNotFound do
      render_status(404, 'Resource Not Found')
    end

    rescue_from Date::Error do
      render_status(400, 'Date Error')
    end

    rescue_from InvalidRegistrationDate do
      render_status(400, 'Invalid Registration Date')
    end
  end
end
