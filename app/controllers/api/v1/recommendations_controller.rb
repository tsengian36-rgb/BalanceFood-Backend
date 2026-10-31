module Api
  module V1
    class RecommendationsController < ApplicationController
      def index
        budget = Integer(params[:budget], exception: false)
        if budget.nil? || budget.negative?
          return render json: { error: "El parámetro budget debe ser un entero mayor o igual a 0" },
                        status: :unprocessable_entity
        end

        render json: BudgetRecommendationService.new(balance: budget).call
      end
    end
  end
end
