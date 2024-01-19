class PeriodsController < ApplicationController
  before_action :find_period, only: [:edit, :update, :destroy]
  include Authorizable
  
  def index
    @page_title = 'Periods'
    @periods = current_user.periods.where.not(end: nil).order(start: :desc)
  end

  def new
    @period = current_user.periods.new
  end

  def create
  end

  def edit
    @page_title = 'Edit period'
  end

  def update
    if @period.update(period_params)
      redirect_to periods_path, notice: 'Period successfully updated'
    else
      render :edit
    end
  end

  def destroy
    return if @period.blank?
    
    if @period.destroy
      redirect_to periods_path, notice: 'Period was successfully deleted'
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
      redirect_to categories_path, alert: 'Something go wrong'
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
      redirect_to categories_path, alert: 'Period was not saved'
    end
  end

  private

  def period_params
    params.require(:period).permit(:start, :end, :category_id)
  end

  def find_period
    @period = Period.find(params[:id])
  end

  def prepare_and_respond
    @categories = current_user.categories.where(parent_id: nil)
    @unfinished_period = Category.any_unfinished_periods_for_user(current_user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to categories_path }
    end
  end
end