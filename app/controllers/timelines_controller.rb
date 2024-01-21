class TimelinesController < ApplicationController
  def update
    @categories_for_timeline = current_user.categories_for_timeline

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to timer_path }
    end
  end
end