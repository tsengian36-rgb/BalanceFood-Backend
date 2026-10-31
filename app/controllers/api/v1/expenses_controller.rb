module Api
  module V1
    class ExpensesController < ApplicationController
      before_action :set_expense, only: %i[show update destroy]

      def index
        expenses = current_user.expenses.includes(:menu_item).order(spent_on: :desc, id: :desc)
        render json: expenses.as_json(methods: :menu_item_name)
      end

      def show
        render json: @expense.as_json(methods: :menu_item_name)
      end

      def create
        expense = current_user.expenses.new(expense_params)
        if expense.save
          render json: expense.as_json(methods: :menu_item_name), status: :created
        else
          render_validation_errors(expense)
        end
      end

      def update
        if @expense.update(expense_params)
          render json: @expense.as_json(methods: :menu_item_name)
        else
          render_validation_errors(@expense)
        end
      end

      def destroy
        @expense.destroy
        head :no_content
      end

      private

      # Solo busca entre los gastos del usuario autenticado (los ajenos dan 404).
      def set_expense
        @expense = current_user.expenses.find(params[:id])
      end

      def expense_params
        params.require(:expense).permit(:description, :amount, :spent_on, :menu_item_id)
      end
    end
  end
end
