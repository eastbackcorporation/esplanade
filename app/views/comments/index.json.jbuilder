json.array!(@comments) do |comment|
  json.extract! comment, :id, :value, :topic_id, :user_id
  json.url comment_url(comment, format: :json)
end
