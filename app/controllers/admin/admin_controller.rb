class Admin::AdminController < ApplicationController
  include Authorizable

  before_action :require_admin
  layout 'admin'
end