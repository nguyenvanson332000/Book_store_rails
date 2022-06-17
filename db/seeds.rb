# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User.create!(name:                  "admin",
#              email:                 "admin@gmail.com",
#              password:              "123456",
#              password_confirmation: "123456",
#              phone_number:                 "0394235659",
#              id_card:                 "123456789",
#              admin:                 true,
#              confirmed_at: Time.zone.now)
# 50.times do |n|
#   name  =     Faker::Name.name
#   email =     "example-#{n+1}@railstutorial.org"
#   password =  "password"
#   phone_number = "84#{Faker::Number.leading_zero_number(digits: 8)}"
#   address = Faker::Address.full_address
#   User.create!(name:                  name,
#               email:                  email,
#               phone_number:           phone_number,
#               password:               password,
#               password_confirmation:  password,
#               address:                address,
#               confirmed_at: Time.zone.now,
#               created_at: rand(2.years).seconds.ago)
# end

# 100.times do |n|
#   name  =  Faker::Book.title + "s"
#   quantity = Faker::Number.between(from: 50, to: 100)
#   price =     5000*(Faker::Number.between(from: 1, to: 10).to_i)
#   status = "Hot"
#   author = Faker::Book.author
#   publisher = Faker::Book.publisher
#   description = Faker::Lorem.paragraph(sentence_count: 10, supplemental: true)
#   category_id = Faker::Number.between(from: 1, to: 10)
#   p = Product.create(name:                  name,
#                     quantity:               quantity,
#                     price:                  price,
#                     status:                 status,
#                     author:                 author,
#                     publisher:              publisher,
#                     description:            description,
#                     category_id:            category_id,
#                     created_at: rand(2.years).seconds.ago)
#                   # byebug
#   p.image.attach(io: File.open("app/assets/images/anh_mau1.png"), filename: "anh_mau.png")
#   p.save!
# end


# 500.times do |n|
#   name  =  Faker::Book.title
#   quantity = Faker::Number.between(from: 50, to: 100)
#   price =     5000*(Faker::Number.between(from: 1, to: 10).to_i)
#   status = "New"
#   author = Faker::Book.author
#   publisher = Faker::Book.publisher
#   description = Faker::Lorem.paragraph(sentence_count: 10, supplemental: true)
#   category_id = Faker::Number.between(from: 1, to: 10)
#   p = Product.create(name:                  name,
#                     quantity:               quantity,
#                     price:                  price,
#                     status:                 status,
#                     author:                 author,
#                     publisher:              publisher,
#                     description:            description,
#                     category_id:            category_id,
#                     created_at: rand(2.years).seconds.ago)
#   p.image.attach(io: File.open("app/assets/images/anh_mau1.png"), filename: "anh_mau.png")
#   p.save!
# end

# 300.times do |n|
#   name  =  Faker::Book.title
#   quantity = Faker::Number.between(from: 50, to: 100)
#   price =     5000*(Faker::Number.between(from: 1, to: 10).to_i)
#   status = "New"
#   author = Faker::Book.author + publisher = Faker::Book.publisher
#   publisher = Faker::Book.publisher
#   description = Faker::Lorem.paragraph(sentence_count: 10, supplemental: true)
#   category_id = Faker::Number.between(from: 1, to: 10)
#   p = Product.create(name:                  name,
#                     quantity:               quantity,
#                     price:                  price,
#                     status:                 status,
#                     author:                 author,
#                     publisher:              publisher,
#                     description:            description,
#                     category_id:            category_id,
#                     created_at: rand(2.years).seconds.ago)
#   p.image.attach(io: File.open("app/assets/images/anh_mau1.png"), filename: "anh_mau.png")
#   p.save!
# end


400.times do |n|
  name  =  "A" + Faker::Book.title
  quantity = Faker::Number.between(from: 50, to: 100)
  price =     5000*(Faker::Number.between(from: 1, to: 10).to_i)
  status = "New"
  author = Faker::Book.author
  publisher = Faker::Book.publisher
  description = Faker::Lorem.paragraph(sentence_count: 10, supplemental: true)
  category_id = Faker::Number.between(from: 1, to: 10)
  p = Product.create(name:                  name,
                    quantity:               quantity,
                    price:                  price,
                    status:                 status,
                    author:                 author,
                    publisher:              publisher,
                    description:            description,
                    category_id:            category_id,
                    created_at: rand(2.years).seconds.ago)
  p.image.attach(io: open(Faker::LoremFlickr.image(size: "600x600")), filename: Faker::LoremFlickr.image(size: "600x600").split('/').last)
  p.save!
end
