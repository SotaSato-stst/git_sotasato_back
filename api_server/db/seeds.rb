# 開発用のテストデータ
if Rails.env.development?
  subsidy_hashes = [
    {
      title: '雇用調整助成金',
      url: 'https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/koyou_roudou/koyou/kyufukin/pageL07.html'
    },
    {
      title: 'ものづくり補助金',
      url: 'https://portal.monodukuri-hojo.jp/'
    },
    {
      title: 'IT導入補助金',
      url: 'https://www.it-hojo.jp/applicant/'
    }
  ]
  subsidy_hashes.each do |hash|
    Subsidy.create(title: hash[:title], url: hash[:url])
  end
end
