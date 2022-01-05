ActiveRecord::Base.logger = Logger.new($stdout)
Rails.logger.level = Logger::DEBUG

# 開発用のテストデータ

if Rails.env.development?
  %w[厚生労働省 経済産業省].each do |name|
    Ministry.create_or_find_by(name: name)
  end
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
    subsidy = Subsidy.find_or_initialize_by(title: hash[:title], url: hash[:url])
    subsidy.update(ministry: ministries[hash[:ministry_name]])
  end
end
