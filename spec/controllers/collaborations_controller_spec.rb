require 'rails_helper'

RSpec.describe CollaborationsController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }

  describe '#index' do
    before do
      get :index, { wiki_id: wiki.to_param }, user_id: user.id
    end
    it 'renders index' do
      expect(response).to render_template('collaborations/index')
    end
  end

  describe '#create' do
    before do
      post :create, { wiki_id: wiki.to_param, collaboration: { user_id: user_2.id } }, user_id: user.id
    end
    it 'creates collaboration' do
      expect(wiki.collaborations.last.user).to eq(user_2)
    end
    it 'has no error' do
      expect(assigns(:collaboration).errors).to be_empty
    end
    it 'redirects to wiki_collaborations' do
      expect(response).to redirect_to(wiki_collaborations_path(wiki))
    end
  end

  describe '#destroy' do
    let(:collaboration) { create(:collaboration, user: user_2, page_id: wiki.id) }
    before do
      delete :destroy, { id: collaboration.id }, user_id: user.id
    end
    it 'destroys collaboration' do
      expect(wiki.collaborations.last).to eq(nil)
    end
    it 'redirects to wiki_collaborations' do
      expect(response).to redirect_to(wiki_collaborations_path(wiki))
    end
  end
end
