# == Schema Information
#
# Table name: ministries
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
#  index_ministries_on_name  (name) UNIQUE
#
class Ministry < ApplicationRecord
end
