class TagSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :slug
end
