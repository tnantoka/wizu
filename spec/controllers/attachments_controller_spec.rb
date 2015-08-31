require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }
  let(:attachment) { create(:attachment, :image, page_id: wiki.id) }

  describe '#index' do
    before do
      get :index, { wiki_id: wiki.to_param }, user_id: user.id
    end
    it 'renders index' do
      expect(response).to render_template('attachments/index')
    end
  end

  describe '#show' do
    before do
      get :show, { id: attachment.to_param }, user_id: user.id
    end
    it 'returns attachment' do
      expect(response.body).to eq(File.binread(Rails.root.join('spec', 'fixtures', 'image.png')))
    end
  end

  describe '#create' do
    context 'with valid params' do
      before do
        post :create, { wiki_id: wiki.to_param, attachment: { data: fixture_file_upload('text.txt', 'text/plain'), page_id: wiki.id } }, user_id: user.id
      end
      it 'creates attachment' do
        expect(wiki.attachments.last.data_file_name).to eq('text.txt')
      end
      it 'has no error' do
        expect(assigns(:attachment).errors).to be_empty
      end
      it 'responds attachment json' do
        expect(response.body).to eq(wiki.attachments.last.to_builder.target!)
      end
    end
    context 'with invalid params' do
      before do
        post :create, { wiki_id: wiki.to_param, attachment: { data: '', page_id: wiki.id } }, user_id: user.id
      end
      it 'does not create page' do
        expect(wiki.attachments.last).to eq(nil)
      end
      it 'has errors' do
        expect(assigns(:attachment).errors).to_not be_empty
      end
      it 'responds errors json' do
        expect(response.body).to eq(assigns(:attachment).errors.to_json)
      end
    end
  end

  describe '#destroy' do
    before do
      delete :destroy, { id: attachment.to_param }, user_id: user.id
    end
    it 'destroys page' do
      expect(Attachment.find_by(id: attachment.id)).to eq(nil)
    end
    it 'redirects to attachments' do
      expect(response).to redirect_to(wiki_attachments_path(wiki))
    end
  end
end
