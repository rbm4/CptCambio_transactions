class Api::V1::UsersController < ApplicationController
    before_action :verify_key, only: [:create], raise: false
    before_action :authenticate_request, only: [:show], raise: false
    skip_before_action :verify_authenticity_token
    
    def show
        user = Auser.find(params[:id])
        
        render(json: user)
    end
    def create #função de API para tratar os users vindos do PayPortal
        user = Auser.new(email: params[:email], password: params[:password])
        if user.save
            render(json: user, status: :ok)
        else
            render(text: user.errors, status: 406)
        end
    end
end