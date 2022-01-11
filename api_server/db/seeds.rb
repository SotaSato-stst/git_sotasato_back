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
      ministry_name: '厚生労働省'
    },
    {
      title: 'ものづくり補助金',
      url: 'https://portal.monodukuri-hojo.jp/',
      ministry_name: '経済産業省'
    },
    {
      title: 'IT導入補助金',
      url: 'https://www.it-hojo.jp/applicant/',
      ministry_name: '経済産業省'
    }
  ]
  subsidy_hashes.each do |hash|
    subsidy = Subsidy.find_or_initialize_by(url: hash[:url])
    subsidy.update(title: hash[:title], ministry: ministries[hash[:ministry_name]])
  end
end
