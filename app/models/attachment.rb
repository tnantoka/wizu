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

class Attachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :page

  validates :slug, uniqueness: { case_sensitive: false }, allow_blank: true

  before_save :set_slug, if: 'slug.blank?'

  scope :recent, -> { order(updated_at: :desc) }

  has_attached_file :data
  validates_attachment :data, presence: true, size: { less_than: 30.megabytes }
  do_not_validate_attachment_file_type :data

  def image?
    !!(data_content_type =~ /image/) 
  end

  def pages
    Page.where('content LIKE ?', "%#{slug}%")
  end

  def to_param
    slug
  end

  def to_builder
    Jbuilder.new do |json|
      json.path Rails.application.routes.url_helpers.attachment_path(self)
      json.is_image image?
      json.file_name data_file_name
    end
  end

  private
    def set_slug
      begin
        slug = SecureRandom.urlsafe_base64(10)
      end while self.class.exists?(slug: slug)
      self.slug = slug
    end
end
