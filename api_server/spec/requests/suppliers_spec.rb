require 'rails_helper'

RSpec.describe 'Suppliers API', type: :request do
  before do
    create(:supplier, name: '経済産業省')
  end

  describe 'GET /suppliers' do
    subject { get '/suppliers' }

    it 'successes' do
      subject
      expect(response.status).to eq 200
    end

    it 'returns object' do
      subject
      expect(json['suppliers'][0]['name']).to eq '経済産業省'
    end
  end
end
