class PublicController < ApplicationController
  def index
    if current_user
      redirect_to timer_path
    end
  end
end