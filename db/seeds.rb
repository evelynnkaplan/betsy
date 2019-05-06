require 'faker'
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do 
  merchant = Merchant.new
  merchant.uid = nil
  merchant.provider = "github"
  merchant.name = Faker::Company.name
  merchant.email = Faker::Internet.email
  merchant.username = Faker::Twitter.screen_name

  merchant.save
  puts "#{merchant.uid} #{merchant.name} saved successfully."
end

25.times do
  # category = ["US Government", "A-list celebrities", "Politicians", "Musicians", "Movies Stars").sample
  product = Product.new
  product.name = Faker::TvShows::BreakingBad.unique.character
  product.merchant_id = Merchant.all.sample.id
  product.stock = rand(1..100)
  product.price = rand(1..1000000)
  product.description = Faker::Lorem.sentence
  product.img_url = Faker::LoremFlickr.image

  product.save
  puts "#{product.name}, #{product.price} saved successfully."
end


