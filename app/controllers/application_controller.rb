class ApplicationController < ActionController::Base
  layout :choose_layout

  private

  def choose_layout
    user_signed_in? ? 'application' : 'public'
  end
end
