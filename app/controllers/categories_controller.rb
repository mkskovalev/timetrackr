class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy, :update_position]
  before_action :set_title, only: [:index, :new, :edit]
  
  include Authorizable

  def index
    @categories = current_user.categories.includes(children: :periods).where(parent_id: nil).sorted
    @unfinished_period = Category.any_unfinished_periods_for_user(current_user)
    @categories_for_timeline = current_user.categories_for_timeline

    total_seconds_today = current_user.periods.sum { |period| period.total_seconds_for_date(Time.now.to_date) }

    @total_time_for_today = CategoriesAnalyticsService.seconds_to_time_format(total_seconds_today, true)
  end

  def show
    @page_title = t('.category')

    @total_time = CategoriesAnalyticsService.seconds_to_time_format(@category.total_seconds, true)

    earliest_start = Period.where(category_id: @category.ids_including_children).minimum(:start)
    total_seconds = CategoriesAnalyticsService.average_time_per_day_in_range(@category, earliest_start, Time.now)
    @avg_time = CategoriesAnalyticsService.seconds_to_time_format(total_seconds, true)

    @time_by_months = ChartDataService.time_by_months_with_format(current_user, @category)

    @grouped_periods = Period.group_periods_by_date(@category.all_periods)
  end

  def new
    @category = current_user.categories.new
    @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
  end

  def create
    @category = current_user.categories.new(category_params)

    Category.transaction do 
      @category.increment_position

      if @category.save
        redirect_to tracker_path, success: t('.success')
      else
        @categories = current_user.categories.left_outer_joins(:periods).where(periods: { id: nil })
        render :new
      end
    end
  end

  def edit
    @categories = current_user.categories
                              .left_outer_joins(:periods)
                              .where(periods: { id: nil })
                              .where.not(id: params[:id])
  end

  def update
    @category.move_to_bottom

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

  def update_position
    new_position = params[:category][:position].to_i

    ActiveRecord::Base.transaction do
      @category.insert_at(new_position)
    end
  
    if @category.errors.empty?
      head :ok
    else
      render json: { ok: false, errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { ok: false, errors: [e.message] }, status: :unprocessable_entity
  end

  def report_modal_content
    @category = Category.find(params[:id])
    @report = Report.new
    render partial: 'categories/report_modal_content', locals: { category: @category, report: @report }
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id, :color, :position)
  end

  def find_category
    @category = current_user.categories.find(params[:id])
  end

  def set_title
    @page_title = t('.title')
  end
end