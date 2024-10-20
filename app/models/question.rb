class Question < ApplicationRecord
  belongs_to :survey
  has_many :responses
  has_many :options, dependent: :destroy
end
