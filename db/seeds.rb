# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:                  "admin",
             email:                 "admin@gmail.com",
             password:              "123456",
             password_confirmation: "123456",
             phone_number:                 "0394235659",
             id_card:                 "123456789",
             admin:                 true,
             confirmed_at: Time.zone.now)
50.times do |n|
  name  =     Faker::Name.name
  email =     "example-#{n+1}@railstutorial.org"
  password =  "password"
  phone_number = "84#{Faker::Number.leading_zero_number(digits: 8)}"
  address = Faker::Address.full_address
  User.create!(name:                  name,
              email:                  email,
              phone_number:           phone_number,
              password:               password,
              password_confirmation:  password,
              address:                address,
              confirmed_at: Time.zone.now,
              created_at: rand(2.years).seconds.ago)
end
