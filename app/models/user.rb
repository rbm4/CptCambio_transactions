class User < ActiveRecord::Base
    has_many :operation, dependent: :destroy
end
