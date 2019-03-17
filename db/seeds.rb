p 'seeding data'

10.times do
  User.create({
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'password',
  })
end

p 'created ten(10) users'

20.times do
  Document.create({
    title: Faker::Book.title,
    body: Faker::Lorem.paragraph,
    access: %w(public private role_based).sample,
    user_id: User.ids.sample,
  })
end

p 'created twenty(20) documents'
