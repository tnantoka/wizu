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

class Wiki < Page
  default_scope -> { where(parent_id: nil) }

  private
    def content_required?
      false
    end
end
