class PeriodsController < ApplicationController
  def run
    @period = Period.new(period_params)
    @period.user_id = current_user.id

    if @period.save
      @categories = current_user.categories.where(parent_id: nil)
      respond_to do |format|
        format.turbo_stream
      end
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
      @categories = current_user.categories.where(parent_id: nil)
      respond_to do |format|
        format.turbo_stream
      end
    else
      redirect_to categories_path, alert: 'Period was not saved'
    end
  end

  private

  def period_params
    params.require(:period).permit(:start, :end, :category_id)
  end
end