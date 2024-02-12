class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  before_action :set_title, only: [:index, :new, :edit]
  
  include Authorizable

  def index
    @categories = current_user.categories.includes(children: :periods).where(parent_id: nil)
    @unfinished_period = Category.any_unfinished_periods_for_user(current_user)
    @categories_for_timeline = current_user.categories_for_timeline

    total_seconds_today = current_user.periods.sum { |period| period.total_seconds_for_date(Time.now.to_date) }

    @total_time_for_today = CategoriesAnalyticsService.seconds_to_time_format(total_seconds_today, true)
  end

  def show
    @page_title = "#{ t('.category') } #{ @category.name }"
    @periods_by_day = ChartDataService.aggregate_periods_by_days(@category, 14)
    @total_time_last_30_days = CategoriesAnalyticsService.total_time_last_30_days(@category)
    @time_difference = CategoriesAnalyticsService.calculate_time_difference(@category)
    @avg_time_last_30_days = CategoriesAnalyticsService.average_time_per_day_last_30_days(@category)
    @avg_time_difference = CategoriesAnalyticsService.average_time_difference_last_60_days(@category)

    category_ids = [@category.id] + @category.descendants.pluck(:id)
    @last_5_periods = current_user.periods.where(category_id: category_ids).where.not(end: nil).order(start: :desc).first(5)
  end

  def new
    @category = current_user.categories.new
    @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
  end

  def create
    @category = current_user.categories.new(category_params)

    if @category.save
      redirect_to tracker_path, success: t('.success')
    else
      @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
      render :new
    end
  end

  def edit
    @categories = current_user.categories
                              .left_outer_joins(:periods)
                              .where(periods: { id: nil })
                              .where.not(id: params[:id])
  end

  def update
    if @category.update(category_params)
      redirect_to tracker_path, success: t('.success')
    else
      @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
      render :edit
    end 
  end

  def destroy
    return if @category.blank?
    
    if @category.destroy
      redirect_to tracker_path, success: t('.success')
    else
      redirect_to tracker_path, danger: t('.error')
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id, :color)
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def set_title
    @page_title = t('.title')
  end
end