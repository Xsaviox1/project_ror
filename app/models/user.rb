class User < ApplicationRecord
    has_many :surveys
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    has_secure_password
end
