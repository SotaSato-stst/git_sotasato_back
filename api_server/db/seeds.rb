ActiveRecord::Base.logger = Logger.new($stdout)
Rails.logger.level = Logger::DEBUG

# 開発用のテストデータ

if Rails.env.development?
  %w[厚生労働省 経済産業省].each do |name|
    Ministry.create_or_find_by!(name: name)
  end
  ministries = Ministry.all.index_by(&:name)

  subsidy_hashes = [
    {
      title: '雇用調整助成金',
      url: 'https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/koyou_roudou/koyou/kyufukin/pageL07.html',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '厚生労働省'
    },
    {
      title: 'ものづくり補助金',
      url: 'https://portal.monodukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '経済産業省'
    },
    {
      title: 'IT導入補助金',
      url: 'https://www.it-hojo.jp/applicant/',
      start_from: "2022-01-01",
      end_to: "2022-02-01",
      ministry_name: '経済産業省'
    }
  ]
  subsidy_hashes.each do |hash|
    subsidy = Subsidy.find_or_initialize_by(url: hash[:url])
    subsidy.update!(
      title: hash[:title],
      ministry: ministries[hash[:ministry_name]],
      start_from: hash[:start_from],
      end_to: hash[:end_to]
    )
  end
end
