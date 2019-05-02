require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


10.times do 
  merchant = Merchant.new
  merchant.uid: rand(1000..9999)
  merchant.provider: "github"
  merchant.name: Faker::Company.name
  merchant.email: Faker::Email.email
  merchant.username: Faker::Twitter.screen_name

  merchant.save
  puts "#{merchant.uid} #{merchant.name} saved successfully."
end

25.times do
  # category = ["US Government", "A-list celebrities", "Politicians", "Musicians", "Movies Stars").sample
  product = Product.new
  product.name = Faker::TvShows::BreakingBad.character
  product.merchant_id = Merchant.all.sample.id
  product.stock = rand(1..100)
  product.price = rand(1..1000000)
  product.description = Faker::Lorem.sentence
  product.img_url = Faker::LoremFlickr.image

  product.save
  puts "#{product.category}, #{product.name} saved successfully."
end


