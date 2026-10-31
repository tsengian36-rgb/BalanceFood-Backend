module Api
  module V1
    class MenuItemsController < ApplicationController
      before_action :set_menu_item, only: %i[show update destroy]

      def index
        scope = MenuItem.includes(:restaurant).order(:name)
        scope = scope.where(restaurant_id: params[:restaurant_id]) if params[:restaurant_id].present?
        scope = scope.where(category: params[:category]) if params[:category].present?
        scope = scope.where("price >= ?", params[:min_price].to_i) if params[:min_price].present?
        scope = scope.where("price <= ?", params[:max_price].to_i) if params[:max_price].present?
        render json: scope.as_json(methods: :restaurant_name)
      end

      def show
        render json: @menu_item.as_json(methods: :restaurant_name)
      end

      def create
        item = MenuItem.new(menu_item_params)
        if item.save
          render json: item.as_json(methods: :restaurant_name), status: :created
        else
          render_validation_errors(item)
        end
      end

      def update
        if @menu_item.update(menu_item_params)
          render json: @menu_item.as_json(methods: :restaurant_name)
        else
          render_validation_errors(@menu_item)
        end
      end

      def destroy
        @menu_item.destroy
        head :no_content
      end

      private

      def set_menu_item
        @menu_item = MenuItem.find(params[:id])
      end

      def menu_item_params
        params.require(:menu_item).permit(:restaurant_id, :name, :description, :price, :category, :available)
      end
    end
  end
end
