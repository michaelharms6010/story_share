FactoryBot.define do
  factory :user do
    name { "TestName" }
    email { "test@example.com" }
    password { "Password123" }
  end

  # factory :user do
  #   name { Faker::Internet.username(specifier: 3..20) }
  #   email { Faker::Internet.email }
  #   password { Faker::Internet.password }
  # end

  trait :admin do
    admin {true}
  end
end
