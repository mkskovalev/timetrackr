class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = current_user.categories.where(parent_id: nil)
  end

  def new
    @category = current_user.categories.new
    @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
  end

  def create
    @category = current_user.categories.new(category_params)

    if @category.save
      redirect_to categories_path, notice: 'Success'
    else
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end
end