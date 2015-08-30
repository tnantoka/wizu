# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  content    :text(65535)      not null
#  slug       :string(255)      not null
#  ancestry   :string(255)
#  wiki       :boolean          default(FALSE), not null
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

require 'rails_helper'

RSpec.describe Page, type: :model do
  let(:page) { create(:page) }

  describe 'validations' do
    subject { page }
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:slug).case_insensitive }
  end

  describe '#set_slug' do
    it 'sets slug' do
      expect(page.slug).to be_present
    end
  end

  describe '#to_param' do
    it 'uses slug' do
      expect(page.to_param).to eq(page.slug)
    end
  end

  describe '#render' do
    let(:page) { create(:page, content: '[link](url)') }
    it 'returns rendered html' do
      expect(page.render).to eq("<p><a href=\"url\">link</a></p>\n")
    end
  end

  describe '#summary' do
    let(:page) { create(:page, content: '[link](url)') }
    it 'returns summary html' do
      expect(page.summary(3)).to eq('<a href="url">li…</a>')
    end
  end
end
