class TopicSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :url, :publication_date, :image_link, :annonce, :body, :created_at, :updated_at
end
