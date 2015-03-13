json.array!(@events) do |event|
  json.extract! event, :id, :start, :end, :timezone
  json.url event_url(event, format: :json)
end
