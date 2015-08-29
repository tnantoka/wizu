FactoryGirl.define do
  factory :page, class: 'Page' do
    title Faker::Name.title
    content Faker::Lorem.paragraph
  end
end
