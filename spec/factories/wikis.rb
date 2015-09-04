FactoryGirl.define do
  factory :wiki, class: 'Wiki' do
    title Faker::Name.title
    content ''

    trait :public do
      secret false
    end
  end
end
