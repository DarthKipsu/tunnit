json.array!(@events) do |event|
  json.extract! event, :id, :start, :end, :title
  json.url event_url(event)
end
