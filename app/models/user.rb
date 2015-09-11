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

class User < ActiveRecord::Base
  has_one :identity, dependent: :destroy
  has_many :wikis, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_many :attachments, dependent: :nullify
  has_many :collaborations, dependent: :destroy

  validates :nickname, presence: true, uniqueness: { case_sensitive: false }

  class << self
    def find_or_create_with_identity!(identity)
      raw = identity.raw
      info = raw.info
      user = identity.user.presence || new
      user.nickname = info.nickname
      user.image = info.image
      user.save!
      identity.update!(user: user)
      user
    end
  end

  def avatar(size)
    "#{image}&s=#{size}"
  end

  def admin?(wiki)
    wiki.user == self || wiki.collaborations.exists?(user_id: self.id)
  end

  def accessible_wikis
    Wiki.where(id: wikis.pluck(:id) + collaborations.pluck(:page_id))
  end
end
