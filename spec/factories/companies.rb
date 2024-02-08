FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    industry { Faker::Company.industry }
    employee_count { rand(99) }
  end
end
