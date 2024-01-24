class PublicController < ApplicationController
  def index
    if current_user
      redirect_to tracker_path
    end
  end
end