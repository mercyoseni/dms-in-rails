FactoryBot.define do
  factory :document do
    title { Faker::Book.title }
    body { Faker::Lorem.paragraph }
    access { %w(public private role_based).sample }

    user
  end
end
