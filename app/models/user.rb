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

  validates :nickname, presence: true

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
end
