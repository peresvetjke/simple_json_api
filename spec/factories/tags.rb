FactoryBot.define do
  factory :tag do
    name { generate(:title) }
    slug { "/path/to" } 
  end
end
