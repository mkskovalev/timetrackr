class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @page_title = t('.title')
  end
end
