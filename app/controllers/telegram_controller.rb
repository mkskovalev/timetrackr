require 'telegram/bot'

class TelegramController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    update = Telegram::Bot::Types::Update.new(params.permit!)

    if update.message
      handle_message(update.message)
      render json: { status: :ok }
    else
      render json: { status: :unprocessable_entity, error: t('.message_not_found') }, status: 422
    end
  end

  private

  def handle_message(message)
    if message.text.start_with?('/start')
      handle_start_command(message)
    else
      send_message(message.chat.id, t('.unknown_command'))
    end
  end

  def handle_start_command(message)
    if message.text.include?(' ')
      user_id = message.text.split(' ', 2).last.to_i
      user = User.find_by(id: user_id)

      if user
        if user.update(telegram_id: message.from.id, telegram_username: message.from.username)
          send_message(message.chat.id, t('.registration_successful'))
        else
          send_retry_button(message.chat.id)
        end
      else
        send_message(message.chat.id, t('.user_not_found'))
      end
    else
      send_message(message.chat.id, t('.no_email_provided'))
    end
  end

  def send_retry_button(chat_id)
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: t('.retry_button'), callback_data: 'retry_registration')
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    send_message(chat_id, t('.registration_failed'), markup)
  end

  def send_message(chat_id, text, markup = nil)
    token = Rails.application.credentials.telegram[Rails.env.to_sym][:api_token]
    Telegram::Bot::Client.run(token) do |bot|
      bot.api.send_message(chat_id: chat_id, text: text, reply_markup: markup)
    end
  end
end
