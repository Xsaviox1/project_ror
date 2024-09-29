class User < ApplicationRecord
    has_many :surveys
    has_many :responses
end
