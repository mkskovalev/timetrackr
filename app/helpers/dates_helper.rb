module DatesHelper
  def humanize_date(date)
    date == Date.today ? 'Today' : date.strftime('%A, %d %B %Y')
  end
end