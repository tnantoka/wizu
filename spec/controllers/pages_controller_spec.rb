require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }
  let(:page) { create(:page, user: user, parent: wiki) }

  describe '#show' do
    context 'when format is default' do
      before do
        get :show, { id: page.to_param }, user_id: user.id
      end
      it 'renders show' do
        expect(response).to render_template('pages/show')
      end
    end
    context 'when format is html' do
      let(:page) { create(:page, user: user, parent: wiki, content: '#header') }
      before do
        get :show, { id: page.to_param, format: :html }, user_id: user.id
      end
      it 'renders show' do
        expect(response).to_not render_template('pages/show')
        expect(response.body).to eq(page.render(link_filters: [::Filters::InternalLink, ::Filters::RemoveFragment]))
      end
    end
    context 'when format is md' do
      before do
        get :show, { id: page.to_param, format: :md }, user_id: user.id
      end
      it 'renders markdown' do
        expect(response.body).to eq(page.render(format: :md))
      end
    end
  end

  describe '#new' do
    before do
      get :new, { wiki_id: wiki.to_param }, user_id: user.id
    end
    it 'renders new' do
      expect(response).to render_template('pages/new')
    end
  end

  describe '#create' do
    context 'with valid params' do
      before do
        post :create, { wiki_id: wiki.to_param, page: { title: 'title', parent_id: wiki.id } }, user_id: user.id
      end
      it 'creates page' do
        expect(wiki.pages.last.title).to eq('title')
      end
      it 'has no error' do
        expect(assigns(:page).errors).to be_empty
      end
      it 'redirects to page' do
        expect(response).to redirect_to(page_path(wiki.pages.last))
      end
    end
    context 'with invalid params' do
      before do
        post :create, { wiki_id: wiki.to_param, page: { title: '', parent_id: wiki.id } }, user_id: user.id
      end
      it 'does not create page' do
        expect(wiki.pages.last).to eq(nil)
      end
      it 'has errors' do
        expect(assigns(:page).errors).to_not be_empty
      end
      it 'renders new' do
        expect(response).to render_template('pages/new')
      end
    end
  end

  describe '#edit' do
    before do
      get :edit, { id: page.to_param }, user_id: user.id
    end
    it 'renders edit' do
      expect(response).to render_template('pages/edit')
    end
  end

  describe '#update' do
    context 'with valid params' do
      before do
        patch :update, { id: page.to_param, page: { title: 'title' } }, user_id: user.id
      end
      it 'updates page' do
        expect(page.reload.title).to eq('title')
      end
      it 'has no error' do
        expect(assigns(:page).errors).to be_empty
      end
      it 'redirects to page' do
        expect(response).to redirect_to(page_path(page))
      end
    end
    context 'with invalid params' do
      before do
        patch :update, { id: page.to_param, page: { title: '' } }, user_id: user.id
      end
      it 'does not update page' do
        expect(page.reload.title).to_not eq('')
      end
      it 'has errors' do
        expect(assigns(:page).errors).to_not be_empty
      end
      it 'renders edit' do
        expect(response).to render_template('pages/edit')
      end
    end
  end

  describe '#destroy' do
    before do
      delete :destroy, { id: page.to_param }, user_id: user.id
    end
    it 'destroys page' do
      expect(Page.find_by(id: page.id)).to eq(nil)
    end
    it 'redirects to dashboard' do
      expect(response).to redirect_to(wiki_path(wiki))
    end
  end

  describe '#histories' do
    before do
      get :histories, { id: page.to_param }, user_id: user.id
    end
    it 'renders histories' do
      expect(response).to render_template('pages/histories')
    end
  end
end
