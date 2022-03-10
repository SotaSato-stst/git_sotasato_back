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
      assert_response_schema_confirm(200)
    end
  end
end
