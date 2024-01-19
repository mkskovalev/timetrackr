class PublicController < ApplicationController
  def index
    if current_user
      redirect_to categories_path
    end
  end
end