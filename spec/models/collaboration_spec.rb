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

require 'rails_helper'

RSpec.describe Collaboration, type: :model do
end
