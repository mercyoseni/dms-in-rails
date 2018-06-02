5.times do
  User.create({
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email,
    role: %w(admin regular author contributor).sample
  })
end

5.times do
  Document.create({
    title: Faker::Book.title,
    body: Faker::Lorem.paragraph,
    access: %w(public private role_based).sample,
    user_id: %w(1 2 3).sample.to_i
  })
end
