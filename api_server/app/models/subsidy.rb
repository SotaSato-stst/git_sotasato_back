# == Schema Information
#
# Table name: subsidies
#
#  id          :bigint           not null, primary key
#  title       :string(255)      not null
#  url         :text(65535)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  supplier_id :bigint           not null
#
# Indexes
#
#  index_subsidies_on_supplier_id  (supplier_id)
#  index_subsidies_on_url          (url) UNIQUE
#
class Subsidy < ApplicationRecord
  belongs_to :supplier
end
