require "test_helper"

class Api::V1::RestaurantsTest < ActionDispatch::IntegrationTest
  setup { @headers = auth_header_for(users(:estudiante)) }

  test "lista locales autenticado" do
    get "/api/v1/restaurants", headers: @headers
    assert_response :success
  end

  test "sin autenticación responde 401" do
    get "/api/v1/restaurants"
    assert_response :unauthorized
  end

  test "crear, editar y eliminar un local (CRUD completo)" do
    post "/api/v1/restaurants", params: { restaurant: { name: "Nuevo local", category: "Test" } }, headers: @headers
    assert_response :created
    id = JSON.parse(response.body)["id"]

    patch "/api/v1/restaurants/#{id}", params: { restaurant: { name: "Local editado" } }, headers: @headers
    assert_response :success
    assert_equal "Local editado", JSON.parse(response.body)["name"]

    delete "/api/v1/restaurants/#{id}", headers: @headers
    assert_response :no_content

    get "/api/v1/restaurants/#{id}", headers: @headers
    assert_response :not_found
  end

  test "crear con nombre vacío responde 422" do
    post "/api/v1/restaurants", params: { restaurant: { name: "" } }, headers: @headers
    assert_response :unprocessable_entity
  end
end
