class Api::V1::UsersController < Api::V1::BaseController
    def show
        user = User.find(params[:id])
        hash = Hash.new
        hash[user][:operations] = user.operations.all
        render(json: hash)
    end
end