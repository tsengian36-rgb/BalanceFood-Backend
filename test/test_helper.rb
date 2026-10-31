ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all

    # Devuelve el header Authorization con un token válido para el usuario dado.
    def auth_header_for(user)
      { "Authorization" => "Bearer #{JsonWebToken.encode(user.id)}" }
    end
  end
end
