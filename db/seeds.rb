user = User.find_or_create_by!(email: "test@balancefood.cl") do |u|
  u.name = "Estudiante Demo"
  u.password = "Password123"
  u.current_balance = 60_000
end

data = {
  "Casino Central UTEM" => ["Almuerzo", "Menú del día",
                           [["Pastel de choclo", 3800], ["Cazuela de vacuno", 3500], ["Ensalada completa", 2900]]],
  "Sándwich Express"    => ["Comida rápida", "Sándwiches y completos",
                           [["Completo italiano", 2200], ["Barros Luco", 3200], ["Churrasco palta", 3600]]],
  "Sabor Vegano"        => ["Vegetariano", "Opciones vegetarianas y veganas",
                           [["Bowl de quinoa", 4200], ["Lasaña de verduras", 4500]]]
}
data.each do |name, (category, description, items)|
  r = Restaurant.find_or_create_by!(name: name) { |x| x.category = category; x.description = description; x.address = "Santiago Centro" }
  items.each { |n, p| r.menu_items.find_or_create_by!(name: n) { |m| m.price = p; m.category = category } }
end

user.expenses.find_or_create_by!(description: "Almuerzo casino", amount: 3500, spent_on: Date.current)
