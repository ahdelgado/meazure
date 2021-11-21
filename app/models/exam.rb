# frozen_string_literal: true

class Exam < ApplicationRecord
  has_many :registrations
  belongs_to :college
  has_one :exam_window
end
