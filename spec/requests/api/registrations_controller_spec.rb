# frozen_string_literal: true

require 'rails_helper'

describe Api::RegistrationsController do
  let!(:user) { create(:user) }
  let!(:college) { create(:college) }
  let!(:exam) { create(:exam, college: college) }
  let!(:exam_window) { create(:exam_window, exam: exam) }

  describe 'POST #create' do
    let!(:params) do
      {
        first_name: user.first_name,
        last_name: user.last_name,
        phone_number: user.phone_number,
        college_id: college.id,
        exam_id: exam.id,
        start_time: DateTime.now + 2.weeks
      }
    end

    context 'when params are valid and registratable' do
      it 'creates a registration object and returns a 201 ' do
        expect(Registration.count).to eql(0)
        expect { post api_registrations_path(params) }.to(change { Registration.count }.by(1))
        expect(response.successful?).to be_truthy
        expect(response.status).to eql(201)
        registration = Registration.first
        registration_start_time = registration.start_datetime.strftime('%Y-%m-%d %H:%M:%S')
        params_start_time = params[:start_time].utc.strftime('%Y-%m-%d %H:%M:%S')
        expect(registration.user_id).to eql(user.id)
        expect(registration.exam_id).to eql(exam.id)
        expect(registration_start_time).to eql(params_start_time)
        expect(json['user_id']).to eql(user.id)
        expect(json['exam_id']).to eql(exam.id)
        expect(json['start_datetime'].to_datetime.strftime('%Y-%m-%d %H:%M:%S')).to eql(params_start_time)
      end

      it 'creates an API request object logging that request was successful' do
        expect(ApiRequest.count).to eql(0)
        expect { post api_registrations_path(params) }.to(change { ApiRequest.count }.by(1))
        api_request = ApiRequest.first
        expect(api_request.request_method).to eql('POST')
        expect(api_request.controller_class).to eql('Api::RegistrationsController')
        expect(api_request.path).to eql('/registrations')
        expect(api_request.status).to eql('201')
        expect(api_request.message).to eql('Created')
      end
    end

    context 'when params are invalid' do
      before { params[:start_time] = 'Invalid datetime' }
      it 'returns a 400' do
        post api_registrations_path(params)
        expect(response.status).to eql(400)
        expect(json['message']).to eq('Date Error')
      end

      it 'creates an API request object logging that params are invalid' do
        expect { post api_registrations_path(params) }.to(change { ApiRequest.count }.by(1))
        api_request = ApiRequest.first
        expect(api_request.status).to eql('400')
        expect(api_request.message).to eql('Date Error')
      end
    end

    context "when date does not fall within exam's time window" do
      before { params[:start_time] = DateTime.now - 1.year }
      it 'returns a 400' do
        post api_registrations_path(params)
        expect(response.status).to eql(400)
        expect(json['message']).to eq('Invalid Registration Date')
      end

      it 'creates an API request object logging that registration date is invalid' do
        expect { post api_registrations_path(params) }.to(change { ApiRequest.count }.by(1))
        api_request = ApiRequest.first
        expect(api_request.status).to eql('400')
        expect(api_request.message).to eql('Invalid Registration Date')
      end
    end

    context 'when the college is not found in the database' do
      before { params[:college_id] = 0 }
      it 'returns a 404' do
        post api_registrations_path(params)
        expect(response.status).to eql(404)
        expect(json['message']).to eq('Resource Not Found')
      end

      it 'creates an API request object logging that the resource was not found' do
        expect { post api_registrations_path(params) }.to(change { ApiRequest.count }.by(1))
        api_request = ApiRequest.first
        expect(api_request.status).to eql('404')
        expect(api_request.message).to eql('Resource Not Found')
      end
    end

    context 'when the exam is not found in the database' do
      before { params[:exam_id] = 0 }
      it 'returns a 404 if the exam is not found in the database' do
        post api_registrations_path(params)
        expect(response.status).to eql(404)
        expect(json['message']).to eq('Resource Not Found')
      end

      it 'creates an API request object logging that the resource was not found' do
        expect { post api_registrations_path(params) }.to(change { ApiRequest.count }.by(1))
        api_request = ApiRequest.first
        expect(api_request.status).to eql('404')
        expect(api_request.message).to eql('Resource Not Found')
      end
    end
  end
end
