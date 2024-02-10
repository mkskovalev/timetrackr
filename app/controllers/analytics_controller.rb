class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @page_title = t('.title')
  end

  def chart_donut_time_categories_data
    time_period = params[:timePeriod]
    category_level = params[:categoryLevel]
    chart_data = ChartDataService.categories_data_for_chart(current_user, time_period, category_level)

    respond_to do |format|
      format.json { render json: chart_data }
    end
  end

  def chart_bar_hourly_activity_data
    time_period = params[:timePeriod]
    chart_data = ChartDataService.average_hourly_activity(current_user, time_period)
    categories = chart_data.keys
    series = chart_data.values

    respond_to do |format|
      format.json { render json: { categories: categories, series: series } }
    end
  end
end
