# frozen_string_literal: true

class User < ApplicationRecord
  has_many :registrations
  has_one :address, as: :addressable
end
