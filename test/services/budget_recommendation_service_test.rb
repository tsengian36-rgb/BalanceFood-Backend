require "test_helper"

class BudgetRecommendationServiceTest < ActiveSupport::TestCase
  # Miércoles 14 de octubre de 2026: quedan 13 días hábiles en el mes (14 a 31 de octubre, sin fines de semana).
  REFERENCE_DATE = Date.new(2026, 10, 14)

  test "saldo crítico: no alcanza para ningún plato por sobre el límite crítico" do
    service = BudgetRecommendationService.new(balance: 20_000, today: REFERENCE_DATE)
    assert_equal "critico", service.status
    assert service.daily_budget < BudgetRecommendationService::CRITICAL_LIMIT
  end

  test "saldo medio: el presupuesto diario cae en el rango medio" do
    service = BudgetRecommendationService.new(balance: 56_000, today: REFERENCE_DATE)
    assert_equal "medio", service.status
    assert service.daily_budget.between?(BudgetRecommendationService::CRITICAL_LIMIT, BudgetRecommendationService::MEDIUM_LIMIT - 1)
  end

  test "saldo holgado: el presupuesto diario supera el límite medio" do
    service = BudgetRecommendationService.new(balance: 140_000, today: REFERENCE_DATE)
    assert_equal "holgado", service.status
    assert service.daily_budget >= BudgetRecommendationService::MEDIUM_LIMIT
  end

  test "solo recomienda platos disponibles y dentro del presupuesto diario" do
    pastel = menu_items(:pastel)   # 3800, available
    cazuela = menu_items(:cazuela) # 6500, available

    result = BudgetRecommendationService.new(balance: 56_000, today: REFERENCE_DATE).call
    ids = result[:recommendations].map { |i| i["id"] }

    assert_includes ids, pastel.id
    assert_not_includes ids, cazuela.id if result[:daily_budget] < 6500
  end

  test "en el último día hábil del mes el presupuesto diario es todo el saldo restante" do
    last_business_day = Date.new(2026, 10, 30) # viernes, último día hábil de octubre 2026
    service = BudgetRecommendationService.new(balance: 9_000, today: last_business_day)
    assert_equal 1, service.remaining_days
    assert_equal 9_000, service.daily_budget
  end
end
