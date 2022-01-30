require 'rails_helper'

RSpec.describe 'Ministries API', type: :request do
  let(:user) { create(:user) }
  let(:ministry) { create(:ministry) }

  before do
    sign_in_with(user)
  end

  describe 'GET /ministries' do
    subject { get '/ministries' }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end
  end
end
