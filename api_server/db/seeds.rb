ActiveRecord::Base.logger = Logger.new($stdout)
Rails.logger.level = Logger::DEBUG

# 開発用のテストデータ

if Rails.env.development?
  supplier_hashes = [
    {
      name: '厚生労働省',
      organization_type: 'ministry'
    },
    {
      name: '経済産業省',
      organization_type: 'ministry'
    }
  ]
  supplier_hashes.each do |hash|
    supplier = Supplier.find_or_initialize_by(name: hash[:name])
    supplier.update(organization_type: hash[:organization_type])
  end
  suppliers = Supplier.all.index_by(&:name)

  subsidy_hashes = [
    {
      title: '雇用調整助成金',
      url: 'https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/koyou_roudou/koyou/kyufukin/pageL07.html',
      supplier_name: '厚生労働省'
    },
    {
      title: 'ものづくり補助金',
      url: 'https://portal.monodukuri-hojo.jp/',
      supplier_name: '経済産業省'
    },
    {
      title: 'IT導入補助金',
      url: 'https://www.it-hojo.jp/applicant/',
      supplier_name: '経済産業省'
    }
  ]
  subsidy_hashes.each do |hash|
    subsidy = Subsidy.find_or_initialize_by(title: hash[:title], url: hash[:url])
    subsidy.update(supplier: suppliers[hash[:supplier_name]])
  end
end
