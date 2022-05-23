FactoryBot.define do
  sequence(:title)    { |n| "Title #{n}" }
  sequence(:url)      { |n| "path/to/url/#{n}" }
  sequence(:email)    { |n| "user_#{n}@example.com" }
end