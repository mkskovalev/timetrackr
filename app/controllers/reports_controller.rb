class ReportsController < ApplicationController
  layout 'public', only: [:show]
  before_action :set_public_locale, only: [:show]

  def index
    @reports = current_user.reports.order(created_at: :desc)
  end

  def create
    @category = current_user.categories.find(report_params[:category_id])
    @report = current_user.reports.new(report_params)
    @report.pass = SecureRandom.hex(5)

    start_date = @report.start_date
    end_date = @report.end_date
    category_ids = @category.ids_including_children
    periods = current_user.periods.where(category_id: category_ids).where('"start" <= ? AND "end" >= ?', end_date, start_date)  
    
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

  def update
    @category = current_user.categories.find(report_params[:category_id])
    @report = current_user.reports.find_by!(unique_identifier: params[:unique_identifier])

    start_date = Date.parse(report_params[:start_date])
    end_date = Date.parse(report_params[:end_date])
    category_ids = @category.ids_including_children
    periods = current_user.periods.where(category_id: category_ids).where('"start" <= ? AND "end" >= ?', end_date, start_date)  
    
    if periods.exists?
      if @report.update(report_params)
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
    @report = current_user.reports.find_by!(unique_identifier: params[:unique_identifier])

    if @report.pass == params[:pass]
      category_ids = @report.category.ids_including_children
      periods = @report.user.periods.where(category_id: category_ids).order(start: :desc)
      start_date = @report.start_date
      end_date = @report.end_date
      @grouped_periods = current_user.periods.group_periods_by_date_with_limits(periods, start_date, end_date)

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

  def deletion_confirmation_modal_content
    @report = current_user.reports.find_by!(unique_identifier: params[:unique_identifier])
    render partial: 'reports/deletion_confirmation_modal_content', locals: { report: @report }
  end

  def destroy
    @report = current_user.reports.find_by!(unique_identifier: params[:unique_identifier])
    @report_id = @report.id
    @report.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            'report-deletion-content',
            partial: 'reports/report_successfully_deleted'
          ),
          turbo_stream.remove("report-#{@report_id}")
        ]
      end
    end
  end

  private

  def report_params
    params.require(:report).permit(:user_id, :category_id, :start_date, :end_date, :pass)
  end

  def set_public_locale
    @report = Report.find_by!(unique_identifier: params[:unique_identifier])
    I18n.locale = @report.user.try(:locale) || I18n.default_locale
  end
end
