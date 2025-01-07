module ApplicationHelper
  def format_date(date, format = "%d %b %Y") = date&.strftime(format)
end
