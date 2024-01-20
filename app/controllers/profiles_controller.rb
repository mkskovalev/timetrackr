class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @page_title = 'Profile'
  end

  def update
    if current_user.update(user_params)
      flash[:notice] = 'Profile was successfully updated'
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to profile_path }
      end
    else
      render :show, alert: 'Profile was not updated'
    end
  end

  private

  def user_params
    params.permit(:timezone)
  end
end
