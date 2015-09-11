# == Schema Information
#
# Table name: collaborations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  page_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_collaborations_on_page_id  (page_id)
#  index_collaborations_on_user_id  (user_id)
#

class Collaboration < ActiveRecord::Base
  belongs_to :user
  belongs_to :page

  def wiki
    page
  end
end
