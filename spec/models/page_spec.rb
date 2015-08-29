# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  content    :text(65535)      not null
#  slug       :string(255)      not null
#  parent_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_pages_on_parent_id  (parent_id)
#  index_pages_on_slug       (slug) UNIQUE
#  index_pages_on_user_id    (user_id)
#

require 'rails_helper'

RSpec.describe Page, type: :model do
  let(:page) { create(:page) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end

  describe '#set_slug' do
    it 'sets slug' do
      expect(page.slug).to be_present
    end
  end
end
