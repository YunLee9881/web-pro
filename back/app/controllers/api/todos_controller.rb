module Api
  class TodosController < ApplicationController
    def index
      @todos = Todo.all
      render json: @todos
    end

    def create
      @todo = Todo.new(todo_params)
      if @todo.save
        render json: @todo, status: :created
      else
        render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      @todo = Todo.find(params[:id])
      if @todo.update(todo_params)
        render json: @todo
      else
        render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Todo not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def destroy
      @todo = Todo.find(params[:id])
      @todo.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Todo not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def todo_params
      params.require(:todo).permit(:title, :completed)
    end
  end
end 