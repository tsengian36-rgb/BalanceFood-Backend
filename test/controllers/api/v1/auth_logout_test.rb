require "test_helper"

class Api::V1::AuthLogoutTest < ActionDispatch::IntegrationTest
  test "después del logout el mismo token recibe 401" do
    user = users(:estudiante)
    headers = auth_header_for(user)

    get "/api/v1/auth/me", headers: headers
    assert_response :success

    delete "/api/v1/auth/logout", headers: headers
    assert_response :success

    get "/api/v1/auth/me", headers: headers
    assert_response :unauthorized
  end

  test "sin token responde 401" do
    get "/api/v1/auth/me"
    assert_response :unauthorized
  end

  test "login con credenciales incorrectas responde 401" do
    post "/api/v1/auth/login", params: { email: users(:estudiante).email, password: "incorrecta" }
    assert_response :unauthorized
  end

  test "signup con datos inválidos responde 422" do
    post "/api/v1/auth/signup", params: { user: { name: "", email: "no-es-correo", password: "123" } }
    assert_response :unprocessable_entity
  end
end
