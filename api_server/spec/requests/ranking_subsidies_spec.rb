require 'rails_helper'

RSpec.describe 'ranking_subsidies API', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in_with(user)
  end

  describe 'GET /ranking_subsidies' do
    subject { get '/ranking_subsidies' }

    let(:ministry) { create(:ministry, name: '経済産業省') }
    let!(:subsidy) do
      create(
        :subsidy,
        title: 'ものづくり補助金',
        url: 'https://portal.monodukuri-hojo.jp/',
        ministry: ministry,
        start_from: Date.yesterday,
        end_to: 1.year.from_now,
        publishing_code: 'published'
      )
    end

    # it 'returns correct response' do
    #   subject
    #   assert_response_schema_confirm(200)
    # end

    it 'returns object' do
      subject
      expect(json['subsidies'][0]['title']).to eq 'ものづくり補助金'
      expect(json['subsidies'][0]['url']).to eq 'https://portal.monodukuri-hojo.jp/'
    end
  end

  describe 'test ranking order' do
    subject { get '/ranking_subsidies' }

    before do
      create(:subsidy, title: '2nd', ranking_score: 50, start_from: Date.yesterday, end_to: 1.year.from_now, publishing_code: 'published')
      create(:subsidy, title: '1st', ranking_score: 80, start_from: Date.yesterday, end_to: 1.year.from_now, publishing_code: 'published')
      create(:subsidy, title: '3rd', ranking_score: 30, start_from: Date.yesterday, end_to: 1.year.from_now, publishing_code: 'published')
    end

    it 'returns object' do
      subject
      titles_order = json['subsidies'].map { |s| s['title'] }
      expect(titles_order).to match %w[1st 2nd 3rd]
    end
  end
end
