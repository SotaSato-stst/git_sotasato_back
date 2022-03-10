require 'rails_helper'

RSpec.describe 'OrganizationTypes API', type: :request do
  describe 'GET /organization_types' do
    let(:user) { create(:user) }
    subject { get '/organization_types' }

    before do
      sign_in_with(user)
    end

    it 'returns correct response' do
      subject
      expect(json['organization_types'][0]['key']).to eq 'kabu'
    end
  end
end
