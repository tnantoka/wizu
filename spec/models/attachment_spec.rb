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

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  describe '#image?' do
    context 'with image' do
      subject { create(:attachment, :image).image? }
      it { should eq(true) }
    end
    context 'with text' do
      subject { create(:attachment, :text).image? }
      it { should eq(false) }
    end
  end

  describe 'pages' do
    let!(:attachment) { create(:attachment, :image) }
    let!(:page) { create(:page, content: attachment.slug) }
    it 'returns pages' do
      expect(attachment.pages).to eq([page])
    end
  end
end
