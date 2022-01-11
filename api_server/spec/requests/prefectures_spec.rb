require 'rails_helper'

RSpec.describe 'Prefectures API', type: :request do
  let(:prefecture) { create(:prefecture) }

  describe 'GET /prefectures' do
    subject { get '/prefectures' }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end
  end

  let(:city) { create(:city, prefecture: prefecture) }

  describe 'GET /prefectures/:id/cities' do
    subject { get "/prefectures/#{prefecture.id}/cities" }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end
  end
end
