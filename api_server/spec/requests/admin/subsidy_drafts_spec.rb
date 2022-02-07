require 'rails_helper'

RSpec.describe 'Subsidy Drafts API', type: :request do
  let(:user) { create(:user, :admin) }
  let(:ministry) { create(:ministry, name: '経済産業省') }
  let!(:subsidy_draft) do
    create(:subsidy_draft, title: 'ものづくり補助金', url: 'https://portal.monodukuri-hojo.jp/', ministry: ministry)
  end

  before do
    sign_in_with(user)
  end

  describe 'GET /admin/subsidy_drafts' do
    subject { get '/admin/subsidy_drafts' }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end

    it 'returns object' do
      subject
      expect(json['subsidy_drafts'][0]['title']).to eq 'ものづくり補助金'
      expect(json['subsidy_drafts'][0]['url']).to eq 'https://portal.monodukuri-hojo.jp/'
      expect(json['subsidy_drafts'][0]['ministry']['name']).to eq '経済産業省'
    end
  end

  describe 'GET /admin/subsidy_drafts/:id' do
    subject { get "/admin/subsidy_drafts/#{subsidy_draft.id}" }

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
