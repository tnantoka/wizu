FactoryGirl.define do
  factory :wiki, class: 'Wiki' do
    title Faker::Name.title
    content ''
  end
end
