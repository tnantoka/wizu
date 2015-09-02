# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  content    :text(16777215)
#  slug       :string(255)      not null
#  ancestry   :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_pages_on_ancestry  (ancestry)
#  index_pages_on_slug      (slug) UNIQUE
#  index_pages_on_user_id   (user_id)
#

FactoryGirl.define do
  factory :page, class: 'Page' do
    title Faker::Name.title
    content Faker::Lorem.paragraph
    parent { create(:wiki) }
  end
end
