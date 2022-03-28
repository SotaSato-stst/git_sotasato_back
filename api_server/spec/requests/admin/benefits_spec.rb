require 'rails_helper'

RSpec.describe 'Admin Benefits', type: :request do
  let(:sign_in_user) { create(:user, :admin) }

  before do
    sign_in_with(sign_in_user)
  end

  let!(:benefit) { create(:benefit) }

  describe 'GET /benefits' do
    subject { get '/admin/benefits' }

    it 'returns object' do
      subject
      expect(json['benefits'][0]['title']).to eq benefit.title
      expect(json['benefits'][0]['url']).to eq benefit.url
    end
  end

  describe 'GET /benefits/:id' do
    subject { get "/admin/benefits/#{benefit.id}" }

    it 'returns object' do
      subject
      expect(json['title']).to eq benefit.title
      expect(json['url']).to eq benefit.url
    end
  end
end
