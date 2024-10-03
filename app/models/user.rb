class User < ApplicationRecord
    has_many :surveys

    has_secure_password
end
