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

class Page < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true, if: :content_required?
  validates :slug, uniqueness: { case_sensitive: false }, allow_blank: true

  before_save :set_slug, if: 'slug.blank?'

  scope :recent, -> { order(updated_at: :desc) }

  def to_param
    slug
  end

  def render
    processor = Qiita::Markdown::Processor.new
    output_html(processor)
  end

  def summary(length)
    processor = Qiita::Markdown::SummaryProcessor.new(truncate: { length: length })
    output_html(processor)
  end

  def set_slug
    begin
      slug = SecureRandom.urlsafe_base64(10)
    end while self.class.exists?(slug: slug)
    self.slug = slug
  end

  private
    def content_required?
      true
    end

    def output_html(processor)
      processed = processor.call(content.to_s)
      fragment = processed[:output]
      fragment.to_html.html_safe
    end
end
