class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @page_title = 'Analytics'
  end
end
