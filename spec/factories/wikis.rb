FactoryGirl.define do
  factory :wiki, class: 'Wiki' do
    title Faker::Name.title
    content ''
    wiki true
  end
end
