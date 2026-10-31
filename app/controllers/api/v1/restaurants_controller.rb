module Api
  module V1
    class RestaurantsController < ApplicationController
      before_action :set_restaurant, only: %i[show update destroy]

      def index
        scope = Restaurant.order(:name)
        scope = scope.where(category: params[:category]) if params[:category].present?
        if params[:q].present?
          scope = scope.where("name ILIKE ?", "%#{Restaurant.sanitize_sql_like(params[:q])}%")
        end
        render json: scope
      end

      def show
        render json: @restaurant.as_json(include: :menu_items)
      end

      def create
        restaurant = Restaurant.new(restaurant_params)
        if restaurant.save
          render json: restaurant, status: :created
        else
          render_validation_errors(restaurant)
        end
      end

      def update
        if @restaurant.update(restaurant_params)
          render json: @restaurant
        else
          render_validation_errors(@restaurant)
        end
      end

      def destroy
        @restaurant.destroy
        head :no_content
      end

      private

      def set_restaurant
        @restaurant = Restaurant.find(params[:id])
      end

      def restaurant_params
        params.require(:restaurant).permit(:name, :category, :address, :description)
      end
    end
  end
end
