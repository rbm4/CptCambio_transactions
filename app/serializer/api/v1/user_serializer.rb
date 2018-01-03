class Api::V1::UserSerializer
  attributes :id, :email, :name,  :id_original, :username, :created_at, :updated_at

  has_many :operations

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end