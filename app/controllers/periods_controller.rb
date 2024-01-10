class PeriodsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @page_title = 'Periods'
    @periods = current_user.periods.all
  end

  def new
    @period = current_user.periods.new
  end

  def run
    @period = Period.new(period_params)
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
    @period.end = period_params[:end]
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

  def prepare_and_respond
    @categories = current_user.categories.where(parent_id: nil)
    @unfinished_period = Category.any_unfinished_periods_for_user(current_user)

    respond_to do |format|
      format.turbo_stream
    end
  end
end