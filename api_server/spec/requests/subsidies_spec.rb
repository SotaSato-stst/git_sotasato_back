require 'rails_helper'

RSpec.describe 'Subsidies API', type: :request do
  before do
    create(:subsidy, title: 'ものづくり補助金', url: 'https://portal.monodukuri-hojo.jp/')
  end

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
    end
  end
end
