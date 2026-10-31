require "swagger_helper"

RSpec.describe "api/v1/restaurants", type: :request do
  let!(:user) { User.create!(name: "Demo", email: "restaurantes@balancefood.cl", password: "Password123") }
  let(:Authorization) { "Bearer #{JsonWebToken.encode(user.id)}" }

  path "/api/v1/restaurants" do
    get "Lista los locales" do
      tags "Locales"
      security [ bearerAuth: [] ]
      produces "application/json"
      parameter name: :category, in: :query, type: :string, required: false
      parameter name: :q, in: :query, type: :string, required: false

      response "200", "listado de locales" do
        run_test!
      end
    end

    post "Crea un local" do
      tags "Locales"
      security [ bearerAuth: [] ]
      consumes "application/json"
      parameter name: :restaurant, in: :body, schema: {
        type: :object,
        properties: {
          restaurant: {
            type: :object,
            properties: { name: { type: :string }, category: { type: :string }, address: { type: :string }, description: { type: :string } },
            required: %w[name]
          }
        }
      }

      response "201", "local creado" do
        let(:restaurant) { { restaurant: { name: "Local de prueba", category: "Almuerzo" } } }
        run_test!
      end

      response "422", "nombre vacío" do
        let(:restaurant) { { restaurant: { name: "" } } }
        run_test!
      end
    end
  end

  path "/api/v1/restaurants/{id}" do
    parameter name: :id, in: :path, type: :integer

    let(:restaurant_record) { Restaurant.create!(name: "Local existente") }
    let(:id) { restaurant_record.id }

    get "Muestra un local" do
      tags "Locales"
      security [ bearerAuth: [] ]
      produces "application/json"
      response "200", "local encontrado" do
        run_test!
      end
      response "404", "no existe" do
        let(:id) { 0 }
        run_test!
      end
    end

    patch "Edita un local" do
      tags "Locales"
      security [ bearerAuth: [] ]
      consumes "application/json"
      parameter name: :restaurant, in: :body, schema: { type: :object, properties: { restaurant: { type: :object } } }
      response "200", "local editado" do
        let(:restaurant) { { restaurant: { name: "Nombre actualizado" } } }
        run_test!
      end
    end

    delete "Elimina un local" do
      tags "Locales"
      security [ bearerAuth: [] ]
      response "204", "local eliminado" do
        run_test!
      end
    end
  end
end
