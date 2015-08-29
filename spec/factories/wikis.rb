FactoryGirl.define do
  factory :wiki, class: 'Wiki' do
    title Faker::Name.title
  end
end
