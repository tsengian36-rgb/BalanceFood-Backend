require "rails_helper"

RSpec.configure do |config|
  config.openapi_root = Rails.root.join("swagger").to_s

  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "BalanceFood API",
        version: "v1",
        description: "API de BalanceFood: autenticación JWT, catálogo de locales y platos, gastos y recomendador de presupuesto."
      },
      paths: {},
      servers: [
        { url: "{defaultHost}", variables: { defaultHost: { default: "http://localhost:3000" } } }
      ],
      components: {
        securitySchemes: {
          bearerAuth: { type: :http, scheme: :bearer, bearerFormat: "JWT" }
        }
      }
    }
  }

  config.openapi_format = :yaml
end
