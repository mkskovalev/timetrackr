class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @page_title = t('.page_title')
    @subscriptions = current_user.subscriptions_hash
  end

  def update
    if current_user.update(user_params)
      redirect_to profile_path, success: I18n.t('profiles.show.profile_success')
    else
      render :show
    end
  end

  private

  def user_params
    params.permit(:timezone, :locale)
  end
end
