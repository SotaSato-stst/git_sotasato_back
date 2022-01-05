# == Schema Information
#
# Table name: subsidies
#
#  id         :bigint           not null, primary key
#  title      :string(255)      not null
#  url        :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subsidies_on_url  (url) UNIQUE
#
class Subsidy < ApplicationRecord
  has_one :subsidy_ministry
  has_one :ministry, through: :subsidy_ministry
  has_one :subsidy_prefecture
  has_one :prefecture, through: :subsidy_prefecture
  has_one :subsidy_city
  has_one :city, through: :subsidy_city
end
