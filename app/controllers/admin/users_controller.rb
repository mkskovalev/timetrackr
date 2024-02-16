class Admin::UsersController < Admin::AdminController
  def index
    @page_title = 'All users'
    @users = User.all
  end
end