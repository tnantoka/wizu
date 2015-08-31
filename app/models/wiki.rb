# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  content    :text(16777215)
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

class Wiki < Page
  default_scope -> { where(wiki: true) }

  def pages
    descendants
  end

  def attachments
    Attachment.where(page_id: subtree_ids)
  end
end
