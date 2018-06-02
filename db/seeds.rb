5.times do
  User.create({
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email,
    role: %w(admin regular author contributor).sample
  })
end
