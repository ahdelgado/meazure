# frozen_string_literal: true

module Api
  class InvalidRegistrationDate < StandardError; end

  class RegistrationsController < Api::ApiController
    def create
      raise InvalidRegistrationDate unless registratable?

      if college
        registration = Registration.create!(user: user, exam: exam, start_datetime: start_datetime)
        ApiRequest.create!(request_method: request.request_method, controller_class: request.controller_class,
                           path: request.path, status: 201, message: 'Created')
      end
      render json: registration, status: :created
    end

    private

    def safe_params
      params.permit(:first_name, :last_name, :phone_number, :college_id, :exam_id, :source_id, :start_time)
    end

    def exam
      @exam ||= Exam.find_by!(id: safe_params[:exam_id])
    end

    def college
      @college ||= College.find_by!(id: safe_params[:college_id])
    end

    def start_datetime
      @start_datetime = safe_params[:start_time].to_datetime.utc
    end

    def user
      @user ||= User.find_or_create_by!(first_name: safe_params[:first_name], last_name: safe_params[:last_name],
                                        phone_number: safe_params[:phone_number])
    end

    def registratable?
      start_datetime.after?(exam.exam_window.start_datetime) && start_datetime.before?(exam.exam_window.end_datetime)
    end
  end
end
