require 'rails_helper'

RSpec.describe 'Subsidies API', type: :request do
  let(:supplier) { create(:supplier, name: '経済産業省') }
  let!(:subsidy) { create(:subsidy, title: 'ものづくり補助金', url: 'https://portal.monodukuri-hojo.jp/', supplier: supplier) }

  describe 'GET /subsidies' do
    subject { get '/subsidies' }

    it 'successes' do
      subject
      expect(response.status).to eq 200
    end

    it 'returns object' do
      subject
      expect(json['subsidies'][0]['title']).to eq 'ものづくり補助金'
      expect(json['subsidies'][0]['url']).to eq 'https://portal.monodukuri-hojo.jp/'
      expect(json['subsidies'][0]['supplier']['name']).to eq '経済産業省'
    end
  end

  describe 'GET /subsidies/:id' do
    subject { get "/subsidies/#{subsidy.id}" }

    it 'successes' do
      subject
      expect(response.status).to eq 200
    end

    it 'returns object' do
      subject
      expect(json['title']).to eq 'ものづくり補助金'
      expect(json['url']).to eq 'https://portal.monodukuri-hojo.jp/'
      expect(json['supplier']['name']).to eq '経済産業省'
    end
  end
end
