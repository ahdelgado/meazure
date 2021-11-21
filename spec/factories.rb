# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.phone_number }
  end

  factory :registration do
    association :user
    association :exam
  end

  factory :exam do
    name { 'Software Architecture' }
    course { 'Full Stack Development' }
    professor { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    association :college
  end

  factory :exam_window do
    start_datetime { 3.months.ago }
    end_datetime { DateTime.now + 3.months }
  end

  factory :college do
    name { 'Department of Computer Science' }
    phone_number { Faker::PhoneNumber.phone_number }
  end

  factory :address do
    address1 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }
    association :addressable, factory: %i[user college]
  end
end
