# Codifica y decodifica JWT (HS256) firmados con secret_key_base.
class JsonWebToken
  ALGORITHM = "HS256".freeze

  def self.encode(user_id, expires_at: 24.hours.from_now)
    payload = { user_id: user_id, jti: SecureRandom.uuid, exp: expires_at.to_i }
    JWT.encode(payload, secret, ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, secret, true, algorithm: ALGORITHM).first.with_indifferent_access
  end

  def self.secret
    Rails.application.secret_key_base
  end
end
