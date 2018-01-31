class Api::V1::UsersController < ApplicationController
    before_action :authenticate_request, only: [:show], raise: false
    def show
        user = User.find(params[:id])
        
        render(json: user)
    end
    def create #função de API para tratar os users vindos do PayPortal
        user = User.new
    end
end