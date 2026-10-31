# BalanceFood — API (backend)

API REST de **BalanceFood**: plataforma para que estudiantes con la Beca de Alimentación JUNAEB comparen precios de platos, registren sus gastos y sepan cuánto pueden gastar cada día para que el saldo les alcance hasta fin de mes.

Proyecto de la asignatura **Computación Web y Móvil** (UTEM) — Tarea 1: Aplicación Web.
Autor: Ian Nicolás Tseng Pereira.

Frontend: https://github.com/tsengian36-rgb/balancefood-frontend

## Stack

Ruby 3.3 · Rails 7.1 (modo API) · PostgreSQL · JWT (HS256) · bcrypt · Swagger (rswag)

## Puesta en marcha

Requisitos: Ruby 3.3, Bundler y PostgreSQL 14 o superior.

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails s            # http://localhost:3000
```

Usuario de prueba (creado por `db:seed`): `test@balancefood.cl` / `Password123`

### Variables de entorno

| Variable | Uso |
|---|---|
| `DB_HOST`, `DB_USERNAME`, `DB_PASSWORD` | Conexión a PostgreSQL en desarrollo y test (por defecto `localhost`, `postgres`, `postgres`) |
| `FRONTEND_ORIGIN` | Orígenes permitidos por CORS, separados por coma (por defecto `http://localhost:5173`) |
| `DATABASE_URL` | Conexión a PostgreSQL en producción |
| `SECRET_KEY_BASE` | Clave con la que se firman los JWT en producción (`bin/rails secret`) |
| `RAILS_ENV` | `production` en el despliegue |

## Autenticación

1. `POST /api/v1/auth/signup` y `POST /api/v1/auth/login` devuelven un JWT HS256 con `user_id`, `jti` (id único) y `exp` (24 horas). Las contraseñas se guardan con bcrypt (`has_secure_password`).
2. Cada request protegida envía `Authorization: Bearer <token>`. `ApplicationController#authenticate_request!` verifica la firma, el vencimiento y que el `jti` no esté revocado.
3. `DELETE /api/v1/auth/logout` guarda el `jti` en la tabla `revoked_tokens`: ese token deja de servir aunque no haya expirado.

## Endpoints (`/api/v1`)

| Módulo | Endpoints |
|---|---|
| Auth | `POST /auth/signup`, `POST /auth/login`, `DELETE /auth/logout`, `GET /auth/me` |
| Locales | `GET /restaurants`, `POST /restaurants`, `GET/PATCH/DELETE /restaurants/:id` (filtros `category`, `q`) |
| Platos | `GET /menu_items`, `POST /menu_items`, `GET/PATCH/DELETE /menu_items/:id` (filtros `restaurant_id`, `category`, `min_price`, `max_price`) |
| Gastos | `GET /expenses`, `POST /expenses`, `GET/PATCH/DELETE /expenses/:id` (solo los del usuario autenticado) |
| Recomendador | `GET /recommendations?budget=NNNN` |

Todas las rutas, salvo `signup` y `login`, requieren token. Códigos de respuesta: 200, 201, 204, 400, 401, 404 y 422. Los errores tienen la forma `{ "error": "...", "details": { campo: ["..."] } }`.

El recomendador divide el saldo por los días hábiles (lunes a viernes) que quedan del mes y devuelve los platos disponibles cuyo precio cabe en ese presupuesto diario. Clasifica el saldo como `critico` (menos de $3.000 por día), `medio` (menos de $5.000) u `holgado`.

## Modelo de datos

| Tabla | Campos principales |
|---|---|
| `users` | name, email (único), password_digest, current_balance (≥ 0) |
| `restaurants` | name, category, address, description |
| `menu_items` | restaurant_id (FK), name, price (> 0), category, available |
| `expenses` | user_id (FK), menu_item_id (FK opcional), description, amount (> 0), spent_on |
| `revoked_tokens` | jti (único), expires_at |

Precios y montos son enteros en pesos chilenos. Las reglas (`price > 0`, `amount > 0`, `current_balance >= 0`) se validan en los modelos y además con check constraints en PostgreSQL.

## Tests

```bash
bin/rails test
```

- `test/controllers/api/v1/auth_logout_test.rb`: el mismo token recibe 401 después del logout.
- `test/services/budget_recommendation_service_test.rb`: presupuesto diario en saldo crítico, medio y holgado, y último día hábil del mes.
- `test/controllers/api/v1/restaurants_test.rb`: CRUD completo y respuestas 401, 404 y 422.

## Documentación Swagger

```bash
RAILS_ENV=test bin/rails rswag:specs:swaggerize   # genera swagger/v1/swagger.yaml
bin/rails s
```

La documentación queda en http://localhost:3000/api-docs.

## Flujo de trabajo

Ramas `feat/*` → PR a `release` → PR de `release` a `main`. Cada PR contiene un solo cambio con un commit.
