# == Schema Information
#
# Table name: cities
#
#  id            :bigint           not null, primary key
#  logo_url      :string(255)      default(""), not null
#  name          :string(255)      not null
#  url_domain    :string(255)      default(""), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  prefecture_id :bigint           not null
#
# Indexes
#
#  index_cities_on_prefecture_id  (prefecture_id)
#
require 'rails_helper'

RSpec.describe City, type: :model do
  describe '#crate' do
    it do
      expect(create(:city)).to be_present
    end
  end
end
