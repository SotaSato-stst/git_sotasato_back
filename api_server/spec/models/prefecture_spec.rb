# == Schema Information
#
# Table name: prefectures
#
#  id         :bigint           not null, primary key
#  logo_url   :string(255)      default(""), not null
#  name       :string(255)      not null
#  url_domain :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_prefectures_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Prefecture, type: :model do
  describe '#crate' do
    it do
      expect(create(:prefecture)).to be_present
    end
  end
end
