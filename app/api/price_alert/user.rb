module PriceAlert
  class User < Grape::API
    helpers ::PriceAlert::Helpers::ResourceHelper
    format :json
    # prefix :api

    namespace :users do
      desc 'Register a new user'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
        requires :password_confirmation, type: String, desc: 'Password confirmation'
      end
      post :signup do
        user = ::User.new(
          email: params["email"],
          password: params["password"],
          password_confirmation: params["password_confirmation"]
        )

        if user.save
          status 201
          { success: true, token: user.jwt_token }
        else
          error!(user.errors.full_messages, 422)
        end
      end

      desc 'Login an existing user'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
      end
      post :login do
        user = User.find_by(email: params[:email])
        if user&.valid_password?(params[:password])
          status 200
          { success: true, token: user.jwt_token }
        else
          error!('Invalid credentials', 401)
        end
      end
    end
  end
end