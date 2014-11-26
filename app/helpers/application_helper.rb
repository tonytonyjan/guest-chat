module ApplicationHelper
  def message_label message
    type = if message.guest == current_guest
      :warning
    else
      case message.guest.role
      when 'teacher' then :danger
      when 'assistant' then :success
      when 'student' then :primary
      end
    end
    match_data = message.guest.name.match(/(.{4})(.*)/)
    name = link_to(match_data[1], "https://www.moedict.tw/#{u match_data[1]}", target: :_blank) + match_data[2]
    content_tag :span, name, class: "name label label-#{type}"
  end
end
