# == Schema Information
#
# Table name: prefectures
#
#  id         :bigint           not null, primary key
#  logo_url   :string(255)      default(""), not null
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_prefectures_on_name  (name) UNIQUE
#
class Prefecture < ApplicationRecord
end