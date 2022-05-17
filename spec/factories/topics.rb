FactoryBot.define do
  factory :topic do
    title             { generate(:title) }
    url               { generate(:url) }
    publication_date  { Time.now }
    image_link        { "MyString" }
    annonce           { "MyText" }
    body              { "MyText" }
  end
end
