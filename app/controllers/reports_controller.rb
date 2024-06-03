class ReportsController < ApplicationController
  layout 'public', only: [:show]
  before_action :set_locale, only: [:show]

  def index
    @reports = current_user.reports
  end

  def create
    @category = Category.find(report_params[:category_id])
    @report = current_user.reports.new(report_params)
    @report.password = SecureRandom.hex(5)

    start_date = @report.start_date
    end_date = @report.end_date
    category_ids = @category.ids_including_children
    periods = Period.where(category_id: category_ids).where('"start" <= ? AND "end" >= ?', end_date, start_date)  
    
    if periods.exists?
      if @report.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              'modal_content',
              partial: 'reports/report_url',
              locals: { report: @report, category: @category }
            )
          end
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              'modal_content',
              partial: 'categories/report_modal_content',
              locals: { report: @report, category: @category }
            )
          end
        end
      end
    else
      @report.errors.add(:base, t('.no_data'))
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'modal_content',
            partial: 'categories/report_modal_content',
            locals: { report: @report, category: @category }
          )
        end
      end
    end
  end

  def show 
  end

  def access_report
    @report = Report.find_by!(unique_identifier: params[:unique_identifier])

    if @report.password == params[:password]
      category_ids = @report.category.ids_including_children
      periods = @report.user.periods.where(category_id: category_ids).order(start: :desc)
      start_date = @report.start_date
      end_date = @report.end_date
      @grouped_periods = Period.group_periods_by_date_with_limits(periods, start_date, end_date)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'report-content',
            partial: 'reports/report',
            locals: { report: @report, grouped_periods: @grouped_periods }
          )
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'report-content',
            partial: 'reports/password',
            locals: { report: @report, error: true }
          )
        end
      end
    end
  end

  private

  def report_params
    params.require(:report).permit(:user_id, :category_id, :start_date, :end_date)
  end

  def set_locale
    @report = Report.find_by!(unique_identifier: params[:unique_identifier])
    I18n.locale = @report.user.try(:locale) || I18n.default_locale
  end
end
