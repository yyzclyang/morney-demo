FactoryBot.define do
  factory :record do
    amount { 100 }
    category { "outgoings" }
    notes { "吃饭" }
    user
  end
end