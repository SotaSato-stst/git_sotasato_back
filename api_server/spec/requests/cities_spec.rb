require 'rails_helper'

RSpec.describe 'Cities API', type: :request do
  let(:city) { create(:city) }

  describe 'GET /cities' do
    subject { get '/cities' }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end
  end
end
