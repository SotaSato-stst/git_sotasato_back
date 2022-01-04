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
class Supplier < ApplicationRecord
  has_many :subsidies
  enum organization_type: %i[ministry local other] # 省庁、地方自治体、その他
end
