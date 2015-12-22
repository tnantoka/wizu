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
#  secret     :boolean          default(TRUE), not null
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
    let(:wiki) { create(:wiki) }
    let(:page) { create(:page, content: content, parent: wiki) }
    let(:internal) { create(:page, title: 'internal title', content: 'internal content', parent: wiki) }
    let(:external) { 'http://example.com' }
    let(:content) do
      <<-EOD.strip_heredoc
        [link](url)
        http://test.host/p/#{internal.slug}
        !![](http://test.host/p/#{internal.slug})
        #{external}
      EOD
    end
    let(:html) do
      <<-EOD.strip_heredoc
        <p><a href="url">link</a><br>
        <a href="/p/#{internal.slug}" title="http://test.host/p/#{internal.slug}">#{internal.title}</a></p>

        <h1>
        <span id="internal-title" class="fragment"></span><a href="#internal-title"><i class="fa fa-link"></i></a><a href="/p/#{internal.slug}" title="/p/#{internal.slug}">#{internal.title}</a>
        </h1>

        #{internal.render}
        <p><a href="/r?u=#{CGI.escape(external)}" title="#{external}" target="_blank">#{external}</a></p>
      EOD
    end
    it 'returns rendered html' do
      expect(page.render).to eq(html)
    end
  end

  describe '#summary' do
    let(:page) { create(:page, content: '[link](url)') }
    it 'returns summary html' do
      expect(page.summary(3)).to eq('<a href="url">li…</a>')
    end
  end

  describe '#toc' do
    let(:page) { create(:page, content: "# header1\n## header2") }
    it 'returns toc html' do
      expect(page.headers).to eq(2)
      toc = <<-EOD.strip_heredoc
        <ul>
        <li>
        <a href="#header1">header1</a>
        <ul>
        <li>
        <a href="#header2">header2</a>
        </li>
        </ul>
        </li>
        </ul>
      EOD
      expect(page.toc).to eq(toc)
    end
  end
end
