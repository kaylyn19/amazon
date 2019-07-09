# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Review.delete_all
Product.delete_all
User.delete_all

PASSWORD = 'supersecret'
users = User.all

10.times do
  created_at= Faker::Date.backward(365 * 5)
  User.create(
    first_name: Faker::Name.first_name,
    last_name:Faker::Name.last_name,
    email: Faker::Internet.email,
    password: PASSWORD,
    created_at: created_at,
    updated_at: created_at
  )
end
puts "generated #{users.count} user information"


100.times do
  created_at = Faker::Date.backward(365 * 5)
  p = Product.create(
    # Faker is a ruby module. We access classes
    # or other modules inside of it with ::.
    # Here, Hacker is a class inside of the
    # Faker module 
    title: Faker::Hacker.say_something_smart,
    description: Faker::ChuckNorris.fact,
    price: rand(0.0..1000.0).round(2),
    created_at: created_at,
    updated_at: created_at,
    user: users.sample
  )
  if p.valid?
    p.reviews = rand(0..10).times.map do
      Review.new(
        body: Faker::Quote.famous_last_words,
        rating: rand(1..5),
        product: p,
        user: users.sample
        )
    end
  end
end

product = Product.all
review = Review.all
puts "Generated #{product.count} products"
puts "Generated #{review.count} reviews"


