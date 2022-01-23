require 'csv'

ActiveRecord::Base.logger = Logger.new($stdout)
Rails.logger.level = Logger::DEBUG

CSV.open('db/seeds/ministries.csv', headers: true).to_a.each do |row|
  ministry = Ministry.find_or_initialize_by(name: row['name'])
  ministry.update(logo_url: row['logo_url'])
end

CSV.open('db/seeds/prefectures.csv', headers: true).to_a.each do |row|
  prefecture = Prefecture.find_or_initialize_by(id: row['id'])
  prefecture.update(name: row['name'], logo_url: row['logo_url'] || '')
end

CSV.open('db/seeds/cities.csv', headers: true).to_a.each do |row|
  city = City.find_or_initialize_by(name: row['name'])
  city.update(prefecture_id: row['prefecture_id'], logo_url: row['logo_url'] || '')
end

# 開発用のテストデータ
if Rails.env.development?
  ministries = Ministry.all.index_by(&:name)

  subsidy_hashes = [
    {
      title: '雇用調整助成金',
      url: 'https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/koyou_roudou/koyou/kyufukin/pageL07.html',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '厚生労働省',
      publishing_code: 'published',
      price_max: '20,000',
      support_ratio_min: '30',
      support_ratio_max: '80',
      level: '3',
      detail: 'ベテランならいけます',
      target_detail: 'これはすごい補助金です'
    },
    {
      title: 'ものづくり補助金',
      url: 'https://portal.monodukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '厚生労働省',
      publishing_code: 'published',
      price_max: '20,000',
      support_ratio_min: '30',
      support_ratio_max: '80',
      level: '3',
      detail: '普通にむずいです',
      target_detail: 'とんでもないです'
    },
    {
      title: 'IT導入補助金',
      url: 'https://www.it-hojo.jp/applicant/',
      start_from: '2022-01-01',
      end_to: '2022-02-01',
      ministry_name: '厚生労働省',
      publishing_code: 'published',
      price_max: '20,000',
      support_ratio_min: '30',
      support_ratio_max: '80',
      level: '3',
      detail: '普通にいけます',
      target_detail: '全てを変えます'
    }
  ]
  subsidy_hashes.each do |hash|
    subsidy = Subsidy.find_or_initialize_by(url: hash[:url])
    subsidy.update!(
      title: hash[:title],
      ministry: ministries[hash[:ministry_name]],
      start_from: hash[:start_from],
      end_to: hash[:end_to],
      publishing_code: hash[:publishing_code],
      price_max: hash[:price_max],
      support_ratio_min: hash[:support_ratio_min],
      support_ratio_max: hash[:support_ratio_max],
      level: hash[:level],
      detail: hash[:detail],
      target_detail: hash[:target_detail]
    )
  end
  company_hashes = [
    {
      name: '池垣株式会社',
      prefecture_name: '大阪府',
      city_id: '1',
      adress: 'つくば市天久保3丁目12-34',
      capital: '200000',
      total_employee: '200',
      business_scale: 'large'
    },
    {
      name: '池垣物産',
      prefecture_name: '神奈川県',
      city_id: '2',
      adress: '河内長野市南希望が丘30-203',
      capital: '20010',
      total_employee: '3',
      business_scale: 'small_business'
    },
    {
      name: 'IGnet',
      prefecture_name: '香川県',
      city_id: '3',
      adress: '千歳市30-2',
      capital: '5040404',
      total_employee: '30',
      business_scale: 'small_business'
    }
  ]
  prefectures = Prefecture.all.index_by(&:name)
  company_hashes.each do |hash|
    company = Company.find_or_initialize_by(name: hash[:name])
    company.update!(
      prefecture: prefectures[hash[:prefecture_name]],
      capital: hash[:capital],
      city_id: hash[:city_id],
      adress: hash[:adress],
      total_employee: hash[:total_employee],
      business_scale: hash[:business_scale]
    )
  end
end
