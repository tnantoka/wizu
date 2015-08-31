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
