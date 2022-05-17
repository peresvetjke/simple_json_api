# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |t|
  FactoryBot.create(:tag,
    name: "tag_#{t+1}",
    slug: "url/tag_#{t+1}"
  )
end

30.times do |t|
  FactoryBot.create(:topic,
    title: "material_#{t+1}", 
    url: "path/to/material_#{t+1}",
    publication_date: Time.now,
    image_link: "image_link",
    annonce: "text",
    body: "text"
  )
end

Topic.first(5).each do |topic|
  topic.tag_list.add Tag.find(rand(1..5)).name
  topic.save!
end