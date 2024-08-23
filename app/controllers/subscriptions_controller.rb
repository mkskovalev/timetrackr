class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:toggle_channel]

  def toggle_channel
    channel = params[:channel]

    if valid_channel?(channel)
      @subscription.toggle!(channel)
      render json: { success: true }
    else
      render json: { success: false, error: "Invalid channel" }, status: :unprocessable_entity
    end
  end

  private

  def set_subscription
    if params[:type].blank?
      return render json: { success: false, error: "Subscription type is required" }, status: :bad_request
    end

    @subscription = current_user.subscriptions.find_or_initialize_by(subscription_type: params[:type])
  end

  def valid_channel?(channel)
    Subscription::VALID_CHANNELS.include?(channel)
  end
end
