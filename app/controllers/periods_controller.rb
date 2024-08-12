class PeriodsController < ApplicationController
  before_action :find_period, only: [:edit, :update, :destroy]
  before_action :set_title, only: [:index, :new, :edit]
  
  include Authorizable
  include Pagy::Backend

  def index
    @q = current_user.periods.includes(:category).ransack(params[:q])

    periods = @q.result.order(start: :desc)

    @categories = current_user.categories
                              .joins(:periods)
                              .where.not(level: 0)
                              .distinct

    grouped_periods = Period.group_periods_by_date(periods)
    @pagy, @grouped_periods = pagy_array(grouped_periods.to_a)
  end

  def new
    @period = current_user.periods.new
    @categories = current_user.categories.select { |category| category.can_have_timer? }
  end

  def create
    if period_params[:start].blank?
      flash[:alert] = t('.start_date_is_missing')
      redirect_to new_period_path
      return
    end

    if period_params[:end].blank? && Category.any_unfinished_periods_for_user(current_user)
      flash[:alert] = t('.end_date_is_missing')
      redirect_to new_period_path
      return
    end

    @period = current_user.periods.new(period_params)

    start_time = DateTime.parse(period_params[:start])
    end_time = period_params[:end].present? ? DateTime.parse(period_params[:end]) : 0

    if (start_time < end_time || (end_time.is_a?(Numeric) && end_time.zero?)) && @period.save
      redirect_to periods_path, success: t('.period_success')
    else
      @categories = current_user.categories.select { |category| category.can_have_timer? }
      render :new
    end
  end

  def edit
    @categories = current_user.categories.select { |category| category.can_have_timer? }
  end

  def update
    if period_params[:start].blank?
      flash[:alert] = t('.start_date_is_missing')
      redirect_to edit_period_path
      return
    end

    if period_params[:end].blank? && current_user.periods.where(end: nil).first != @period
      flash[:alert] = t('.end_date_is_missing')
      redirect_to edit_period_path
      return
    end
    
    start_time = DateTime.parse(period_params[:start])
    end_time = period_params[:end].present? ? DateTime.parse(period_params[:end]) : 0

    if (start_time < end_time || (end_time.is_a?(Numeric) && end_time.zero?)) && @period.update(period_params)
      redirect_to periods_path, success: t('.period_success')
    else
      @categories = current_user.categories.select { |category| category.can_have_timer? }
      render :edit
    end
  end

  def destroy
    return if @period.blank?
    
    if @period.destroy
      redirect_to periods_path, notice: t('.period_success')
    else
      redirect_to periods_path, alert: 'Period was not deleted'
    end
  end

  def run
    @period = Period.new(period_params)
    @period.start = DateTime.current
    @period.user_id = current_user.id

    if @period.save
      prepare_and_respond
    else
      redirect_to tracker_path, alert: 'Something go wrong'
    end
  end

  def stop
    @category = current_user.categories.find(period_params[:category_id])
    return unless @category

    @period = @category.periods.find(params[:period_id])
    @period.end = DateTime.current
    @period.user_id = current_user.id

    if @period.save
      prepare_and_respond
    else
      redirect_to tracker_path, alert: 'Period was not saved'
    end
  end

  private

  def period_params
    params.require(:period).permit(:start, :end, :category_id)
  end

  def find_period
    @period = Period.find(params[:id])
  end

  def set_title
    @page_title = t('.title')
  end

  def prepare_and_respond
    @categories = current_user.categories.where(parent_id: nil)
    @unfinished_period = Category.any_unfinished_periods_for_user(current_user)
    @categories_for_timeline = current_user.categories_for_timeline

    total_seconds_today = current_user.periods.sum { |period| period.total_seconds_for_date(Time.now.to_date) }
    @total_time_for_today = CategoriesAnalyticsService.seconds_to_time_format(total_seconds_today, true)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tracker_path }
    end
  end
end