require "swagger_helper"

RSpec.describe "api/v1/recommendations", type: :request do
  let!(:user) { User.create!(name: "Demo", email: "reco@balancefood.cl", password: "Password123") }
  let(:Authorization) { "Bearer #{JsonWebToken.encode(user.id)}" }

  path "/api/v1/recommendations" do
    get "Sugiere platos según el presupuesto diario" do
      tags "Recomendador"
      security [ bearerAuth: [] ]
      produces "application/json"
      parameter name: :budget, in: :query, type: :integer, required: true

      response "200", "recomendaciones calculadas" do
        let(:budget) { 40_000 }
        run_test!
      end

      response "422", "budget inválido" do
        let(:budget) { -5 }
        run_test!
      end
    end
  end
end
