require "swagger_helper"

RSpec.describe "api/v1/auth", type: :request do
  path "/api/v1/auth/signup" do
    post "Crea una cuenta" do
      tags "Auth"
      consumes "application/json"
      produces "application/json"
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              password: { type: :string },
              current_balance: { type: :integer }
            },
            required: %w[name email password]
          }
        }
      }

      response "201", "cuenta creada" do
        let(:user) { { user: { name: "Nueva Persona", email: "nueva@balancefood.cl", password: "Password123", current_balance: 50_000 } } }
        run_test!
      end

      response "422", "datos inválidos" do
        let(:user) { { user: { name: "", email: "no-es-correo", password: "123" } } }
        run_test!
      end
    end
  end

  path "/api/v1/auth/login" do
    post "Inicia sesión" do
      tags "Auth"
      consumes "application/json"
      produces "application/json"
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: { email: { type: :string }, password: { type: :string } }
      }

      response "200", "token entregado" do
        let!(:existing) { User.create!(name: "Demo", email: "demo@balancefood.cl", password: "Password123") }
        let(:credentials) { { email: "demo@balancefood.cl", password: "Password123" } }
        run_test!
      end

      response "401", "credenciales incorrectas" do
        let(:credentials) { { email: "no-existe@balancefood.cl", password: "x" } }
        run_test!
      end
    end
  end

  path "/api/v1/auth/logout" do
    delete "Cierra sesión y revoca el token" do
      tags "Auth"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "200", "sesión cerrada" do
        let!(:user) { User.create!(name: "Demo", email: "demo2@balancefood.cl", password: "Password123") }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user.id)}" }
        run_test!
      end

      response "401", "sin token" do
        let(:Authorization) { "" }
        run_test!
      end
    end
  end

  path "/api/v1/auth/me" do
    get "Devuelve el usuario autenticado" do
      tags "Auth"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "200", "usuario actual" do
        let!(:user) { User.create!(name: "Demo", email: "demo3@balancefood.cl", password: "Password123") }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user.id)}" }
        run_test!
      end
    end
  end
end
