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

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }
    it { should validate_presence_of(:nickname) }
  end

  describe '::find_or_create_with_identity' do
    let(:identity) { Identity.find_or_create_with_auth_hash!(auth_hash) }
    let(:user) { User.find_or_create_with_identity!(identity) }
    it 'creates user with identity' do
      expect(user.nickname).to eq(auth_hash.info.name)
      expect(user.image).to eq(auth_hash.info.image)
    end
  end

  describe '#avatar' do
    let(:user) { create(:user) }
    it 'returns image with size' do
      expect(user.avatar(24)).to eq("#{user.image}&s=24")
    end
  end
end
