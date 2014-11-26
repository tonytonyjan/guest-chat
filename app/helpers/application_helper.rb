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
    content_tag :span, message.guest.name, class: "name label label-#{type}"
  end
end
