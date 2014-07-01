json.array!(@messages) do |message|
  json.extract! message, :id
  json.content RDiscount.new(message.content, :autolink).to_html
  json.guest do
    json.extract! message.guest, :id, :name
  end
end
