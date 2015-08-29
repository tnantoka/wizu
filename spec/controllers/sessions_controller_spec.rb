require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  render_views
  let(:user) { create(:user) }

  describe '#create' do
    before do
      request.env['omniauth.auth'] = auth_hash
      get :create, auth_hash
    end
    it 'sets current_user' do
      expect(session[:user_id]).to eq(User.last.id)
    end
    it 'sets signed_in to notice' do
      expect(flash[:notice]).to eq(I18n.t('flash.sessions.signed_in'))
    end
    it 'redirects to dashboard' do
      expect(response).to redirect_to(:dashboard)
    end
  end

  describe '#destory' do
    before do
      delete :destroy, nil, user_id: user.id
    end
    it 'sets nil to current_user' do
      expect(session[:user_id]).to eq(nil)
    end
    it 'sets signed_out to notice' do
      expect(flash[:notice]).to eq(I18n.t('flash.sessions.signed_out'))
    end
    it 'redirects to root' do
      expect(response).to redirect_to(:root)
    end
  end

  describe '#failure' do
    before do
      get :failure
    end
    it 'sets failed to alert' do
      expect(flash[:alert]).to eq(I18n.t('flash.sessions.failed'))
    end
    it 'redirects to root' do
      expect(response).to redirect_to(:root)
    end
  end
end
