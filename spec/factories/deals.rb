FactoryBot.define do
  factory :deal do
    amount {300}
    name { Faker::Company.name }
    status { Faker::Subscription.status }
    association :company
  end
end
