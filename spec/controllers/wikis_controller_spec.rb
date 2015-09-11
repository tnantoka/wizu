require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }

  describe '#show' do
    before do
      get :show, { id: wiki.to_param }, user_id: user.id
    end
    it 'renders show' do
      expect(response).to render_template('wikis/show')
    end
  end

  describe '#new' do
    before do
      get :new, nil, user_id: user.id
    end
    it 'renders new' do
      expect(response).to render_template('wikis/new')
    end
  end

  describe '#create' do
    context 'with valid params' do
      before do
        post :create, { wiki: { title: 'title' } }, user_id: user.id
      end
      it 'creates wiki' do
        expect(user.wikis.last.title).to eq('title')
      end
      it 'has no error' do
        expect(assigns(:wiki).errors).to be_empty
      end
      it 'redirects to wiki' do
        expect(response).to redirect_to(wiki_path(user.wikis.last))
      end
    end
    context 'with invalid params' do
      before do
        post :create, { wiki: { title: '' } }, user_id: user.id
      end
      it 'does not create wiki' do
        expect(user.wikis.last).to eq(nil)
      end
      it 'has errors' do
        expect(assigns(:wiki).errors).to_not be_empty
      end
      it 'renders new' do
        expect(response).to render_template('wikis/new')
      end
    end
  end

  describe '#edit' do
    before do
      get :edit, { id: wiki.to_param }, user_id: user.id
    end
    it 'renders edit' do
      expect(response).to render_template('wikis/edit')
    end
  end

  describe '#update' do
    context 'with valid params' do
      before do
        patch :update, { id: wiki.to_param, wiki: { title: 'title' } }, user_id: user.id
      end
      it 'updates wiki' do
        expect(wiki.reload.title).to eq('title')
      end
      it 'has no error' do
        expect(assigns(:wiki).errors).to be_empty
      end
      it 'redirects to wiki' do
        expect(response).to redirect_to(wiki_path(wiki))
      end
    end
    context 'with invalid params' do
      before do
        patch :update, { id: wiki.to_param, wiki: { title: '' } }, user_id: user.id
      end
      it 'does not update wiki' do
        expect(wiki.reload.title).to_not eq('')
      end
      it 'has errors' do
        expect(assigns(:wiki).errors).to_not be_empty
      end
      it 'renders edit' do
        expect(response).to render_template('wikis/edit')
      end
    end
  end

  describe '#destroy' do
    before do
      delete :destroy, { id: wiki.to_param }, user_id: user.id
    end
    it 'destroys wiki' do
      expect(Wiki.find_by(id: wiki.id)).to eq(nil)
    end
    it 'redirects to dashboard' do
      expect(response).to redirect_to(:dashboard)
    end
  end

  describe '#tree' do
    before do
      get :tree, { id: wiki.to_param }, user_id: user.id
    end
    it 'renders tree' do
      expect(response).to render_template('wikis/tree')
    end
  end

  describe '#search' do
    let!(:pages) { create_list(:page, 5, title: 'title', parent: wiki) }
    before do
      get :search, { id: wiki.to_param, q: 'title' }, user_id: user.id
    end
    it 'sets pages' do
      expect(assigns(:pages).size).to eq(pages.size)
    end
  end

  describe '#authorize' do
    let(:user_2) { create(:user) }
    context 'with private wiki' do
      before do
        get :show, { id: wiki.to_param }, user_id: user_2.id
      end
      it 'rendirects to root' do
        expect(response).to redirect_to(:root)
      end
    end
    context 'with public wiki' do
      let(:wiki) { create(:wiki, :public, user: user) }
      before do
        get :show, { id: wiki.to_param }, user_id: user_2.id
      end
      it 'renders show' do
        expect(response).to render_template('wikis/show')
      end
    end
  end

  describe '#activities' do
    before do
      get :activities, { id: wiki.to_param }, user_id: user.id
    end
    it 'renders activities' do
      expect(response).to render_template('wikis/activities')
    end
  end
end
