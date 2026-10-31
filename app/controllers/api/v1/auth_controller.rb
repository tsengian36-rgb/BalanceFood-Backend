module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request!, only: %i[signup login]

      def signup
        user = User.new(signup_params)
        if user.save
          render json: { token: JsonWebToken.encode(user.id), user: user_json(user) }, status: :created
        else
          render_validation_errors(user)
        end
      end

      def login
        user = User.find_by(email: params[:email].to_s.strip.downcase)
        if user&.authenticate(params[:password].to_s)
          render json: { token: JsonWebToken.encode(user.id), user: user_json(user) }
        else
          render json: { error: "Correo o contraseña incorrectos" }, status: :unauthorized
        end
      end

      # Revoca el jti del token actual: el JWT deja de ser válido aunque no haya expirado.
      def logout
        RevokedToken.find_or_create_by!(jti: @token_payload[:jti]) do |t|
          t.expires_at = Time.at(@token_payload[:exp])
        end
        render json: { message: "Sesión cerrada" }
      end

      def me
        render json: user_json(current_user)
      end

      private

      def signup_params
        params.require(:user).permit(:name, :email, :password, :current_balance)
      end

      def user_json(user)
        user.as_json(only: %i[id name email current_balance])
      end
    end
  end
end
