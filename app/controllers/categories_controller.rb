class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @page_title = 'Categories'
    @categories = current_user.categories.includes(childrens: :periods).where(parent_id: nil)
    @unfinished_period = Category.any_unfinished_periods_for_user(current_user)
  end

  def new
    @page_title = 'New category'
    @category = current_user.categories.new
    @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
  end

  def create
    @category = current_user.categories.new(category_params)

    if @category.save
      redirect_to categories_path, notice: 'Category was successfully created'
    else
      render :new
    end
  end

  def edit
    @page_title = 'Edit category'
    @category = current_user.categories.find(params[:id])
    @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
  end

  def update
    @category = current_user.categories.find(params[:id])

    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category was successfully updated'
    else
      render :edit
    end 
  end

  def destroy
    @category = current_user.categories.find(params[:id])
    return if @category.blank?
    
    if @category.destroy
      redirect_to categories_path, notice: 'Category was successfully deleted'
    else
      redirect_to categories_path, alert: 'Category was not deleted'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end
end