FactoryBot.define do
  factory :user do
    name { Faker::Internet.username(specifier: 3..20, separators: %w(_ -)) }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  trait :admin do
    admin {true}
  end
end
