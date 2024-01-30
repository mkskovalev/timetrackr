class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  include Authorizable

  def index
    @page_title = t('.tracker')
    @categories = current_user.categories.includes(children: :periods).where(parent_id: nil)
    @unfinished_period = Category.any_unfinished_periods_for_user(current_user)
    @categories_for_timeline = current_user.categories_for_timeline

    total_seconds_today = current_user.periods.sum { |period| period.total_seconds_for_date(Time.now.to_date) }

    @total_time_for_today = CategoriesAnalyticsService.seconds_to_time_format(total_seconds_today)
  end

  def show
    @page_title = "Category #{@category.name}"
    @periods_by_day = ChartDataService.aggregate_periods_by_days(@category, 14)
    @total_time_last_30_days = CategoriesAnalyticsService.total_time_last_30_days(@category)
    @time_difference = CategoriesAnalyticsService.calculate_time_difference(@category)
    @avg_time_last_30_days = CategoriesAnalyticsService.average_time_per_day_last_30_days(@category)
    @avg_time_difference = CategoriesAnalyticsService.average_time_difference_last_60_days(@category)

    category_ids = [@category.id] + @category.descendants.pluck(:id)
    @last_5_periods = current_user.periods.where(category_id: category_ids).where.not(end: nil).order(start: :desc).first(5)
  end

  def new
    @page_title = 'New category'
    @category = current_user.categories.new
    @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
  end

  def create
    @category = current_user.categories.new(category_params)

    if @category.save
      redirect_to tracker_path, notice: 'Category was successfully created'
    else
      @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
      render :new
    end
  end

  def edit
    @page_title = 'Edit category'
    @categories = current_user.categories
                              .left_outer_joins(:periods)
                              .where(periods: { id: nil })
                              .where.not(id: params[:id])
  end

  def update
    if @category.update(category_params)
      redirect_to tracker_path, notice: 'Category was successfully updated'
    else
      @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
      render :edit
    end 
  end

  def destroy
    return if @category.blank?
    
    if @category.destroy
      redirect_to tracker_path, notice: 'Category was successfully deleted'
    else
      redirect_to tracker_path, alert: 'Category was not deleted'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id, :color)
  end

  def find_category
    @category = Category.find(params[:id])
  end
end