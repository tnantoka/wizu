require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  render_views
  let(:user) { create(:user) }

  describe '#index' do
    context 'when signed in' do
      before do
        get :index, nil, user_id: user.id
      end
      it 'redirects to dashboard' do
        expect(response).to redirect_to(:dashboard)
      end
    end
    context 'when signed out' do
      before do
        get :index
      end
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
    context 'with params[:locale]' do
      before do
        get :index, { locale: :ja }
      end
      it 'sets ja to locale' do
        expect(I18n.locale).to eq(:ja)
      end
    end
  end

  describe '#dashboard' do
    context 'when signed in' do
      before do
        create_list(:wiki, 5, user: user)
        get :dashboard, nil, user_id: user.id
      end
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
      it 'assings wikis' do
        expect(assigns[:wikis].size).to eq(user.accessible_wikis.size + 1)
      end
    end
    context 'when signed out' do
      before do
        get :dashboard
      end
      it 'returns to root' do
        expect(response).to redirect_to(:root)
      end
      it 'set unauthenticated to alert' do
        expect(flash[:alert]).to eq(I18n.t('flash.application.unauthenticated'))
      end
    end
  end

  describe '#redirect' do
    let(:url) { 'http://example.com' }
    context 'when referer is valid' do
      it 'redirects to url' do
        request.env["HTTP_REFERER"] = 'http://test.host/'
        get :redirect, u: url
        expect(response).to redirect_to(url)
      end
    end
    context 'when referer is invalid' do
      it 'raises 404' do
        request.env["HTTP_REFERER"] = 'http://example.com/'
        expect {
          get :redirect, u: url
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
