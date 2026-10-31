class ApplicationController < ActionController::API
  before_action :authenticate_request!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  attr_reader :current_user

  private

  def authenticate_request!
    token = request.headers["Authorization"].to_s.split(" ").last
    return unauthorized("Debes iniciar sesión") if token.blank?

    payload = JsonWebToken.decode(token)
    return unauthorized("La sesión fue cerrada") if RevokedToken.exists?(jti: payload[:jti])

    @token_payload = payload
    @current_user = User.find(payload[:user_id])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    unauthorized("Sesión inválida o expirada")
  end

  def unauthorized(message)
    render json: { error: message }, status: :unauthorized
  end

  def not_found
    render json: { error: "Recurso no encontrado" }, status: :not_found
  end

  def bad_request(exception)
    render json: { error: "Falta el parámetro requerido: #{exception.param}" }, status: :bad_request
  end

  def render_validation_errors(record)
    render json: { error: "Datos inválidos", details: record.errors.to_hash }, status: :unprocessable_entity
  end
end
