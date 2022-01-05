require 'rails_helper'

RSpec.describe 'Subsidies API', type: :request do
  let(:ministry) { create(:ministry, name: '経済産業省') }
  let!(:subsidy) { create(:subsidy, title: 'ものづくり補助金', url: 'https://portal.monodukuri-hojo.jp/', ministry: ministry) }

  describe 'GET /subsidies' do
    subject { get '/subsidies' }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end

    it 'returns object' do
      subject
      expect(json['subsidies'][0]['title']).to eq 'ものづくり補助金'
      expect(json['subsidies'][0]['url']).to eq 'https://portal.monodukuri-hojo.jp/'
      expect(json['subsidies'][0]['ministry']['name']).to eq '経済産業省'
    end
  end

  describe 'GET /subsidies/:id' do
    subject { get "/subsidies/#{subsidy.id}" }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end

    it 'returns object' do
      subject
      expect(json['title']).to eq 'ものづくり補助金'
      expect(json['url']).to eq 'https://portal.monodukuri-hojo.jp/'
      expect(json['ministry']['name']).to eq '経済産業省'
    end
  end
end
