module MailersHelper
  def percentage_change(num)
    color = if num > 0
              "#22c55e"  # green
            elsif num < 0
              "#ef4444"  # red
            else
              "#a8a29e"  # gray
            end
  
    arrow = if num > 0
              "&#9650;"  # arrow up
            elsif num < 0
              "&#9660;"  # arrow down
            else
              ""
            end
  
    "<span style='color: #{color};'>#{num}% #{arrow}</span>".html_safe
  end
end