class PeriodsController < ApplicationController
  def run
    @category = current_user.categories.find(params[:category_id])
    return unless @category

    respond_to do |format|
      format.turbo_stream
    end
  end

  def stop
    @category = current_user.categories.find(period_params[:category_id])
    return unless @category

    period = @category.periods.new(period_params)
    period.user_id = current_user.id

    if period.save
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