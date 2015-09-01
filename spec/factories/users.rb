# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nickname   :string(255)      not null
#  image      :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_nickname  (nickname) UNIQUE
#

FactoryGirl.define do
  factory :user, class: 'User' do
    nickname { Faker::Name.name }
    image Faker::Avatar.image
  end
end
