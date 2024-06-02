class ReportsController < ApplicationController
  before_action :authenticate_report, only: [:show]

  def create
    @category = Category.find(report_params[:category_id])
    @report = current_user.reports.new(report_params)
    @report.password = SecureRandom.hex(5)
    
    if @report.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'modal_content',
            partial: 'reports/report_url',
            locals: { report: @report, category: @category }
          )
        end

        format.html { render :show, notice: "Report created. Password: #{@report.password}" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render partial: 'categories/report_modal_content', locals: { category: @category, report: @report }
        end

        format.html { render :new }
      end
    end
  end

  def show
    @report = Report.find_by!(unique_identifier: params[:id])
    # Отчет будет показан после успешной аутентификации
  end

  private

  def authenticate_report
    unless session[@report.unique_identifier] || authenticate_with_http_basic { |_, password| @report.authenticate(password) }
      request_http_basic_authentication
    end
    session[@report.unique_identifier] = true
  end

  def report_params
    params.require(:report).permit(:user_id, :category_id, :start_date, :end_date)
  end
end
