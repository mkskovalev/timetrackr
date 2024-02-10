class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @page_title = t('.title')
  end

  def chart_donut_time_categories_data
    time_period = params[:timePeriod]
    category_level = params[:categoryLevel]

    puts time_period
    puts category_level

    chart_data = ChartDataService.categories_data_for_chart(current_user, time_period, category_level)

    render json: chart_data
  end
end
