module Authorizable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :check_authorization, only: [:edit, :update, :destroy]
  end

  private

  def check_authorization
    resource = instance_variable_get("@#{controller_name.singularize}")
    return if resource&.user == current_user

    redirect_to categories_path, alert: "Access denied: You are not authorized to access this #{controller_name.singularize}"
  end
end
