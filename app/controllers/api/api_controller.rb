# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    def render_status(status, message)
      render json: { message: message }, status: status
    end

    rescue_from ActiveRecord::RecordNotFound do
      render_status(404, 'Resource Not Found')
    end

    rescue_from ActionController::ParameterMissing do
      render_status(:bad_request, 'Bad Request')
    end

    rescue_from Date::Error do
      render_status(:bad_request, 'Bad Request')
    end

    rescue_from InvalidRegistrationDate do
      render_status(:bad_request, 'Invalid Registration Date')
    end
  end
end
