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

class Page < ActiveRecord::Base
  belongs_to :user
  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaboratios, source: :user

  validates :title, presence: true
  validates :slug, uniqueness: { case_sensitive: false }, allow_blank: true

  before_save :set_slug, if: 'slug.blank?'

  scope :recent, -> { order(updated_at: :desc) }
  scope :search, -> q { where('title LIKE ? OR content LIKE ?', "%#{q}%", "%#{q}%") }

  has_ancestry touch: true
  has_paper_trail

  def to_param
    slug
  end

  def render(format: :html, wiki_id: wiki.try(:id))
    processor = Qiita::Markdown::Processor.new(
      wiki_id: wiki_id,
      page_slug: slug,
      format: format
    )
    processor.filters.unshift(::Filters::EmbedPage)
    processor.filters << ::Filters::InternalLink
    processor.filters << ::Filters::ExternalLink

    case format
    when :html
      output_html(processor)
    when :md
      processor.filters.slice!(1..-1)
      output_md(processor)
    end
  end

  def summary(length)
    processor = Qiita::Markdown::SummaryProcessor.new(truncate: { length: length })
    output_html(processor)
  end

  def headers
    content.scan(/^#/).size
  end

  def toc
    renderer = Qiita::Markdown::Greenmat::HTMLToCRenderer.new
    greenmat = Greenmat::Markdown.new(renderer)
    greenmat.render(content.to_s).html_safe
  end

  def set_slug
    begin
      slug = SecureRandom.urlsafe_base64(10)
    end while self.class.exists?(slug: slug)
    self.slug = slug
  end

  def tree(with_root = true, separator = ' / ')
    path.map { |p|
      !with_root && p.root? ? nil : p.title 
    }.compact.join(separator)
  end

  def wiki?
    root?
  end

  def wiki
    root
  end

  def public?
    !wiki.secret?
  end

  private
    def fragment(processor)
      processed = processor.call(content.to_s)
      fragment = processed[:output]
    end

    def output_html(processor)
      fragment(processor).to_html.html_safe
    end

    def output_md(processor)
      fragment(processor)
    end
end
