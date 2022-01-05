require 'rails_helper'

RSpec.describe 'Ministries API', type: :request do
  let(:ministry) { create(:ministry) }

  describe 'GET /ministries' do
    subject { get '/ministries' }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end
  end
end
