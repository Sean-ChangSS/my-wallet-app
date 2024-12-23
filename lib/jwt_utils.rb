# lib/jwt_utils.rb

require "jwt"

module JwtUtils
  # Secret key should retrieve from environment variables in production environment,
  # at here we explicitly defined it for simplicity
  SECRET_KEY = "devSecret"
  ALGORITHM = "HS256"

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
    decoded[0]
  rescue JWT::ExpiredSignature
    raise "Token has expired"
  rescue JWT::DecodeError
    raise "Invalid token"
  end
end
