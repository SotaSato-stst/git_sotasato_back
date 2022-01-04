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
FactoryBot.define do
  factory :supplier do
    name { 'supplier' }
    organization_type { 'ministry' }
    logo_url { 'https://example.com/logo.png' }
  end
end
