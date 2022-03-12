require 'rails_helper'

RSpec.describe 'user_email_unsubscribes API', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in_with(user)
  end

  describe 'GET /user_email_unsubscribes' do
    subject { post '/user_email_unsubscribes', params: params }

    let(:params) { { email_category: 'new_subsidies' } }

    it 'creates object' do
      expect { subject }.to change { user.user_email_unsubscribes.count }.by(1)
    end
  end

  describe 'DELETE /user_email_unsubscribes' do
    subject { delete '/user_email_unsubscribes', params: params }

    let(:params) { { email_category: 'new_subsidies' } }

    context 'when record exists' do
      before { create(:user_email_unsubscribe, user_id: user.id, email_category: 'new_subsidies') }

      it 'creates object' do
        subject
        expect(user.user_email_unsubscribes.count).to eq 0
      end
    end
    context 'when record not exist' do
      it 'creates object' do
        subject
        expect(user.user_email_unsubscribes.count).to eq 0
      end
    end
  end
end
