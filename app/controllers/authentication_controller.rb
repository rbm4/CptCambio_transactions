class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request, raise: false
    skip_before_action :verify_authenticity_token
    def authenticate 
        command = AuthenticateUser.call(params[:email], params[:password]) 
        
        if command.success? 
            render json: { auth_token: command.result } 
        else 
            p JSON.parse(command.errors)
            render json: { error: command.errors }, status: :unauthorized 
        end 
    end
end
