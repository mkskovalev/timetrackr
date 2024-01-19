class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  include Authorizable

  def index
    @page_title = 'Categories'
    @categories = current_user.categories.includes(childrens: :periods).where(parent_id: nil)
    @unfinished_period = Category.any_unfinished_periods_for_user(current_user)
  end

  def show
    @page_title = "Category #{@category.name}"
    @periods_by_day = ChartDataService.aggregate_periods_by_days(@category, 14)
    @total_time_last_30_days = CategoriesAnalyticsService.total_time_last_30_days(@category)
    @time_difference = CategoriesAnalyticsService.calculate_time_difference(@category)
    @avg_time_last_30_days = CategoriesAnalyticsService.average_time_per_day_last_30_days(@category)
    @avg_time_difference = CategoriesAnalyticsService.average_time_difference_last_60_days(@category)
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
    @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category was successfully updated'
    else
      render :edit
    end 
  end

  def destroy
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

  def find_category
    @category = Category.find(params[:id])
  end
end