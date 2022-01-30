require 'rails_helper'

RSpec.describe 'BusinessCategories API', type: :request do
  describe 'GET /business_categories' do
    let(:user) { create(:user) }
    subject { get '/business_categories' }

    before do
      sign_in_with(user)
    end

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end
  end
end
