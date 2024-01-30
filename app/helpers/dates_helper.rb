module DatesHelper
  def humanize_date(date)
    I18n.l(date, format: :long)
  end
end