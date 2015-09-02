# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  slug              :string(255)      not null
#  page_id           :integer
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  data_updated_at   :datetime
#
# Indexes
#
#  index_attachments_on_page_id  (page_id)
#  index_attachments_on_user_id  (user_id)
#

include ActionDispatch::TestProcess 

FactoryGirl.define do
  factory :attachment, class: 'Attachment' do
    trait :image do
      data { fixture_file_upload(Rails.root.join('spec/fixtures/image.png'), 'image/png') }
    end
    trait :text do
      data { fixture_file_upload(Rails.root.join('spec/fixtures/text.txt'), 'text/plain') }
    end
  end
end
