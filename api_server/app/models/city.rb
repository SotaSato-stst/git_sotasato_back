# == Schema Information
#
# Table name: cities
#
#  id            :bigint           not null, primary key
#  logo_url      :string(255)      default(""), not null
#  name          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  prefecture_id :bigint           not null
#
# Indexes
#
#  index_cities_on_prefecture_id  (prefecture_id)
#
class City < ApplicationRecord
  belongs_to :prefecture
  has_many :companies
end
