# == Schema Information
#
# Table name: subsidy_business_categories
#
#  id                :bigint           not null, primary key
#  business_category :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  subsidy_id        :bigint           not null
#
# Indexes
#
#  index_subsidy_business_categories_on_subsidy_id  (subsidy_id)
#  index_unique_subsidy_business_categories         (subsidy_id,business_category) UNIQUE
#
require 'rails_helper'

RSpec.describe SubsidyBusinessCategory, type: :model do
  describe '#create' do
    it do
      expect(create(:subsidy_business_category)).to be_present
    end
  end
end
