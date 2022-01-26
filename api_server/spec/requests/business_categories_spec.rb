require 'rails_helper'

RSpec.describe 'BusinessCategories API', type: :request do
  describe 'GET /business_categories' do
    subject { get '/business_categories' }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end
  end
end
