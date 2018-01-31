class Auser < ApplicationRecord
    has_secure_password
    has_many :operation, dependent: :destroy
end
