require "faker"

["US Government", "Area 51", "World Politics", "Illumanti", "Conspiracies", "Movie Stars", "Celebrities", "Ada Developers Academy", "Misc", "Hidden"].each do |category|
  Category.create(name: category)
end

merchants = [
  {uid: 1, provider: "github", name: "Not Evelynn", email: "evelynn@kaplan.com", username: "notevelynn"},
  {uid: 2, provider: "github", name: "Devin", email: "devin@fakeemail.org", username: "dHelmgren"},
  {uid: 3, provider: "github", name: "Deep Throat", email: "markfelt@fbi.gov", username: "deepthroat"},
  {uid: 4, provider: "github", name: "Dana Scully", email: "scully@fbi.gov", username: "truthisoutthere"},
  {uid: 5, provider: "github", name: "Perez Hilton", email: "philton@fakeemail.com", username: "philton"},
  {uid: 6, provider: "github", name: "Silvio", email: "silvio@fakeemail.com", username: "silviothecat"},
]

merchants.each do |merchant|
  Merchant.create(merchant)
end

products = [
  {name: "Erica's Github Password", merchant_id: Merchant.find_by(uid: 1).id, stock: rand(1..50), price: 5, description: "Git her!", img_url: "https://tinyurl.com/y4l68bfg"},
  {name: "Dan's Middle Name", merchant_id: Merchant.find_by(uid: 2).id, stock: rand(1..50), price: rand(1..10000), description: "Ever wonder what Dan's middle name is? Well now, you can know...", img_url: "https://tinyurl.com/y3hhxnsp"},
  {name: "Who is DB Cooper?", merchant_id: Merchant.find_by(uid: 3).id, stock: rand(1..50), price: rand(1..10000), description: "Everythng you need to know about history's most famous heist.", img_url: "https://tinyurl.com/y66lzalv"},
  {name: "Stupid Watergate", merchant_id: Merchant.find_by(uid: 3).id, stock: rand(1..50), price: rand(1..10000), description: "Like Watergate, but even stupider.", img_url: "https://i.imgur.com/k4yH7iT.png"},
  {name: "Marilyn Monroe", merchant_id: Merchant.find_by(uid: 3).id, stock: rand(1..50), price: rand(1..10000), description: "You already know about JFK, but that's just the beginning...", img_url: "https://tinyurl.com/yyqw94av"},
  {name: "FBI-sanctioned Assassinations", merchant_id: Merchant.find_by(uid: 3).id, stock: rand(1..50), price: rand(1..10000), description: "You know it happens, now you can know to who.", img_url: "https://tinyurl.com/y63snehm"},
  {name: "The Truth behind the Moon Landing", merchant_id: Merchant.find_by(uid: 4).id, stock: rand(1..50), price: rand(1..10000), description: "Whatever you thought happened is incorrect.", img_url: "https://tinyurl.com/yypgey7h"},
  {name: "Known Aliens", merchant_id: Merchant.find_by(uid: 4).id, stock: rand(1..50), price: rand(1..10000), description: "A list of all currently known aliens", img_url: "https://tinyurl.com/yy4ze9ob"},
  {name: "SETI's Secret Files", merchant_id: Merchant.find_by(uid: 4).id, stock: rand(1..50), price: rand(1..10000), description: "The files Search for Extra-Terrestial Intelligence doesn't want you to have", img_url: "https://tinyurl.com/y3vcdvj4"},
  {name: "Area 51 Tell-All Package", merchant_id: Merchant.find_by(uid: 4).id, stock: rand(1..50), price: 20000, description: "A complete breakdown of everything related to Area 51", img_url: "https://tinyurl.com/yy6k7tzw"},
  {name: "Why Ariana Grande broke up with Pete Davidson", merchant_id: Merchant.find_by(uid: 5).id, stock: rand(1..50), price: rand(1..10000), description: "You may think you know, but you have no idea.", img_url: "https://tinyurl.com/y375b6yg"},
  {name: "Beyonce's Next Album", merchant_id: Merchant.find_by(uid: 5).id, stock: rand(1..50), price: rand(1..10000), description: "You already love it, but be the first to find out when the next surprise release is.", img_url: "https://tinyurl.com/y4w2272w"},
  {name: "The Meaning of Zigazig Ha", merchant_id: Merchant.find_by(uid: 5).id, stock: rand(1..50), price: rand(1..10000), description: "It's been 20 years. It's time you find out.", img_url: "https://tinyurl.com/yy3gth87"},
  {name: "JonBenet Ramsey", merchant_id: Merchant.find_by(uid: 5).id, stock: rand(1..50), price: rand(1..10000), description: "Find out the truth behind this decades old mystery", img_url: "https://tinyurl.com/y3k2ddn7"},
  {name: "Who is Becky with the Good Hair", merchant_id: Merchant.find_by(uid: 5).id, stock: rand(1..50), price: rand(1..10000), description: "The biggest mystery of 2016.", img_url: "https://tinyurl.com/y36k3clg"},
  {name: "Royal Baby's Name", merchant_id: Merchant.find_by(uid: 5).id, stock: rand(1..50), price: rand(1..10000), description: "Find out what Prince Harry and Princess Meghan named their first boy.", img_url: "https://tinyurl.com/y4gm7xyv"},
  {name: "Zodiac Killer", merchant_id: Merchant.find_by(uid: 3).id, stock: rand(1..50), price: rand(1..10000), description: "Astrology and murder.", img_url: "https://tinyurl.com/yxlvx8yk"},
  {name: "What is your roomba hiding", merchant_id: Merchant.find_by(uid: 3).id, stock: rand(1..50), price: rand(1..10000), description: "Hint: it isn't just your lint.", img_url: "https://tinyurl.com/yxcxysv9"},
]

products.each do |product|
  Product.create(product)
end

products_categories = [
  {product_name: "Erica's Github Password", categories: ["ada developers academy"]},
  {product_name: "Dan's Middle Name", categories: ["ada developers academy"]},
  {product_name: "Who is DB Cooper?", categories: ["conspiracies"]},
  {product_name: "Stupid Watergate", categories: ["conspiracies", "us government"]},
  {product_name: "Marilyn Monroe", categories: ["us government", "illumanti", "celebrities"]},
  {product_name: "FBI-sanctioned Assassinations", categories: ["conspiracies", "us government"]},
  {product_name: "The Truth behind the Moon Landing", categories: ["conspiracies", "us government", "area 51"]},
  {product_name: "Known Aliens", categories: ["conspiracies", "area 51", "illumanti"]},
  {product_name: "SETI's Secret Files", categories: ["conspiracies", "area 51"]},
  {product_name: "Why Ariana Grande broke up with Pete Davidson", categories: ["celebrities"]},
  {product_name: "Beyonce's Next Album", categories: ["illumanti", "celebrities"]},
  {product_name: "The Meaning of Zigazig Ha", categories: ["illumanti", "celebrities"]},
  {product_name: "JonBenet Ramsey", categories: ["misc"]},
  {product_name: "Who is Becky with the Good Hair", categories: ["illumanti", "celebrities"]},
  {product_name: "Royal Baby's Name", categories: ["hidden"]},
  {product_name: "Zodiac Killer", categories: ["conspiracies"]},
  {product_name: "What is your roomba hiding", categories: ["conspiracies", "illumanti"]},
]

products_categories.each do |group|
  group[:categories].each do |category|
    product = Product.find_by(name: group[:product_name])
    product.categories.push(Category.find_by(name: category))
  end
end
