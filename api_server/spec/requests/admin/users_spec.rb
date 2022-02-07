require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let(:sign_in_user) { create(:user, :admin) }
  let(:user) { create(:user, display_name: 'テスト太郎', email: 'taro@test.com', firebase_uid: 'test') }

  before do
    sign_in_with(sign_in_user)
  end

  describe 'GET /admin/users' do
    subject { get '/admin/users' }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end

    it 'returns object' do
      create(:user, display_name: 'テスト太郎', email: 'taro@test.com', firebase_uid: 'test')
      subject
      expect(json['users'][1]['display_name']).to eq 'テスト太郎'
      expect(json['users'][1]['email']).to eq 'taro@test.com'
      expect(json['users'][1]['firebase_uid']).to eq 'test'
    end

    context 'sign_in_user is not admin' do
      let(:sign_in_user) { create(:user) }

      it 'returns 403' do
        subject
        expect(response.status).to eq 403
      end
    end
  end

  describe 'GET /admin/users/:id' do
    subject { get "/admin/users/#{user.id}" }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end

    it 'returns object' do
      subject
      expect(json['display_name']).to eq 'テスト太郎'
      expect(json['email']).to eq 'taro@test.com'
      expect(json['firebase_uid']).to eq 'test'
    end

    context 'sign_in_user is not admin' do
      let(:sign_in_user) { create(:user) }

      it 'returns 403' do
        subject
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST /admin/users' do
    subject { post '/admin/users', params: params }

    let(:company) { create(:company) }
    let(:params) do
      {
        display_name: 'じろう',
        email: 'jiro@test.com',
        account_role: 'editor',
        company_id: company.id
      }
    end

    before do
      allow_any_instance_of(FirebaseAccountService).to receive(:sign_up!).and_return('jiro@test.com')
    end

    it 'creates a record' do
      subject
      assert_response_schema_confirm(201)
    end

    it 'returns object' do
      subject
      expect(json['display_name']).to eq 'じろう'
      expect(json['email']).to eq 'jiro@test.com'
      expect(json['account_role']).to eq 'editor'
    end

    context 'sign_in_user is not admin' do
      let(:sign_in_user) { create(:user) }

      it 'returns 403' do
        subject
        expect(response.status).to eq 403
      end
    end
  end

  describe 'PUT /admin/users/:id' do
    subject { put "/admin/users/#{user.id}", params: params }

    let(:params) do
      {
        display_name: 'さぶろう',
        email: 'saburo@test.com',
        account_role: 'admin'
      }
    end

    it 'updates a record' do
      subject
      assert_response_schema_confirm(200)
    end

    it 'returns object' do
      subject
      expect(json['display_name']).to eq 'さぶろう'
      expect(json['email']).to eq 'saburo@test.com'
      expect(json['account_role']).to eq 'admin'
    end

    context 'sign_in_user is not admin' do
      let(:sign_in_user) { create(:user) }

      it 'returns 403' do
        subject
        expect(response.status).to eq 403
      end
    end
  end
end
