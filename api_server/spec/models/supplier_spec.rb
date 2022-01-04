# == Schema Information
#
# Table name: suppliers
#
#  id                :bigint           not null, primary key
#  logo_url          :string(255)      default(""), not null
#  name              :string(255)      not null
#  organization_type :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_suppliers_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe '#crate' do
    it do
      expect(create(:supplier)).to be_present
    end
  end
end
