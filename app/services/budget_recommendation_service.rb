# Calcula el presupuesto diario según los días hábiles restantes del mes
# y devuelve los platos que el estudiante puede costear hoy.
class BudgetRecommendationService
  CRITICAL_LIMIT = 3000
  MEDIUM_LIMIT = 5000

  def initialize(balance:, today: Date.current)
    @balance = balance
    @today = today
  end

  def remaining_days
    (@today..@today.end_of_month).count { |d| !d.saturday? && !d.sunday? }
  end

  def daily_budget
    days = remaining_days
    days.zero? ? @balance : (@balance / days.to_f).floor
  end

  def status
    if daily_budget < CRITICAL_LIMIT then "critico"
    elsif daily_budget < MEDIUM_LIMIT then "medio"
    else "holgado"
    end
  end

  def call
    items = MenuItem.includes(:restaurant)
                    .where(available: true)
                    .where("price <= ?", daily_budget)
                    .order(price: :desc)
                    .limit(20)
    {
      balance: @balance,
      remaining_days: remaining_days,
      daily_budget: daily_budget,
      status: status,
      recommendations: items.as_json(methods: :restaurant_name)
    }
  end
end
