# frozen_string_literal: true

class College < ApplicationRecord
  has_many :exams
  has_one :address, as: :addressable
end
