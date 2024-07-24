FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { Faker::Internet.password(min_length: 6) }
    # password { "fooooo" } 今回は指定しないでランダムとした
    sequence(:email) {|n| "#{n}_#{Faker::Internet.email}" }
    # email { Faker::Internet.email }
  end
end
