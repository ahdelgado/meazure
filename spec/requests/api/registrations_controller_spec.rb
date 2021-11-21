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

    it 'creates a registration object and returns a 201 when params are valid and registratable' do
      post api_registrations_path(params)
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

    it 'returns a 400 when params are invalid' do
      params[:start_time] = 'Invalid datetime'
      post api_registrations_path(params)
      expect(response.status).to eql(400)
      expect(json['message']).to eq('Bad Request')
    end

    it "returns a 400 when date does not fall within exam's time window" do
      params[:start_time] = DateTime.now - 1.year
      post api_registrations_path(params)
      expect(response.status).to eql(400)
      expect(json['message']).to eq('Invalid Registration Date')
    end

    it 'returns a 404 if the college is not found in the database' do
      params[:college_id] = 999
      post api_registrations_path(params)
      expect(response.status).to eql(404)
      expect(json['message']).to eq('Resource Not Found')
    end

    it 'returns a 404 if the exam is not found in the database' do
      params[:exam_id] = 999
      post api_registrations_path(params)
      expect(response.status).to eql(404)
      expect(json['message']).to eq('Resource Not Found')
    end
  end
end
