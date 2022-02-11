require 'csv'

ActiveRecord::Base.logger = Logger.new($stdout)
Rails.logger.level = Logger::DEBUG

if Ministry.count.zero?
  CSV.open('db/seeds/ministries.csv', headers: true).to_a.each do |row|
    ministry = Ministry.find_or_initialize_by(name: row['name'])
    ministry.update(
      logo_url: row['logo_url'],
      url_domain: row['url_domain'] || ''
    )
  end
end
if Prefecture.count.zero?
  CSV.open('db/seeds/prefectures.csv', headers: true).to_a.each do |row|
    prefecture = Prefecture.find_or_initialize_by(id: row['id'])
    prefecture.update(
      name: row['name'],
      logo_url: row['logo_url'] || '',
      url_domain: row['url_domain'] || ''
    )
  end
end
if City.count.zero?
  CSV.open('db/seeds/cities.csv', headers: true).to_a.each do |row|
    city = City.find_or_initialize_by(name: row['name'])
    city.update(
      prefecture_id: row['prefecture_id'],
      logo_url: row['logo_url'] || '',
      url_domain: row['url_domain'] || ''
    )
  end
end

# 開発用のテストデータ
if Rails.env.development?
  ministries = Ministry.all.index_by(&:name)
  prefectures = Prefecture.all.index_by(&:name)
  cities = City.all.index_by(&:name)

  subsidy_hashes = [
    {
      title: '雇用調整助成金',
      url: 'https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/koyou_roudou/koyou/kyufukin/pageL07.html',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '厚生労働省',
      prefecture_name: '',
      city_name: '',
      publishing_code: 'published',
      price_max: '16777216',
      support_ratio_min: '30',
      support_ratio_max: '80',
      level: '3',
      detail: '雇用調整助成金とは、「新型コロナウイルス感染症の影響」により、「事業活動の縮小」を余儀なくされた場合に、従業員の雇用維持を図るために、「労使間の協定」に基づき、「雇用調整（休業）」を実施する事業主に対して、休業手当などの一部を助成するものです。',
      target_detail: '新型コロナウイルス感染症に伴う特例措置では、以下の条件を満たす全ての業種の事業主を対象としています。
      １．新型コロナウイルス感染症の影響により経営環境が悪化し、事業活動が縮小している
      ２．最近１か月間の売上高または生産量などが前年同月比５％以上減少している(※)
      ※比較対象とする月についても、柔軟な取り扱いとする特例措置があります。３．労使間の協定に基づき休業などを実施し、休業手当を支払っている',
      subsidy_category: 'josei',
      supplier_type: 'ministry',
      business_categories: ['kensetsu']
    },
    {
      title: 'ものづくり補助金',
      url: 'https://portal.monodukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '経済産業省',
      publishing_code: 'published',
      price_max: '262144',
      support_ratio_min: '30',
      support_ratio_max: '80',
      level: '1',
      detail: 'ものづくり・商業・サービス生産性向上促進補助金は、中小企業・小規模事業者等が今後複数
      年にわたり相次いで直面する制度変更（働き方改革や被用者保険の適用拡大、賃上げ、インボイ
      ス導入等）等に対応するため、中小企業・小規模事業者等が取り組む革新的サービス開発・試作
      品開発・生産プロセスの改善を行うための設備投資等を支援するものです。また、新型コロナウ
      イルスの感染拡大の影響を受け、社会経済の変化に対応したビジネスモデルへの転換に向けた新
      型コロナウイルスの影響を乗り越えるために前向きな投資を行う事業者に対して、通常枠とは別
      に、補助率を引き上げ、営業経費を補助対象とした「新特別枠」として低感染リスク型ビジネス
      枠を新たに設け、優先的に支援します。',
      target_detail: '以下を満たす３～５年の事業計画の策定及び実行
      ・付加価値額 ＋３％以上／年
       ・給与支給総額＋１．５％以上／年
      ・事業場内最低賃金≧地域別最低賃金＋３０円',
      subsidy_category: 'hojo',
      supplier_type: 'ministry',
      business_categories: ['seizo']
    },
    {
      title: '令和３年度茨城県宿泊事業者感染対策支援事業費補助金',
      url: 'https://www.pref.ibaraki.jp/eigyo/kanko/kanko/r3kansentaisaku/r3hojyokin.html',
      start_from: '2022-05-01',
      end_to: '2022-12-01',
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: '',
      publishing_code: 'published',
      price_max: '1000000',
      support_ratio_min: '',
      support_ratio_max: '',
      level: '4',
      detail: '１　感染症対策に資する物品の購入等
      　（サーモグラフィー等の必需品の導入費用、感染症対策の専門家による検証費用等）
      
      ２　前向き投資に要する経費
      　（ワーケーションスペースの設置、非接触チェックインシステムの導入等）
      
      ※令和２年５月14日まで遡及適用可',
      target_detail: '県内宿泊事業者（旅館業法の許可を受けている者）
      ※風営法第２条第６項に規定する店舗型性風俗特殊営業を営む者は除く',
      subsidy_category: 'hojo',
      supplier_type: 'prefecture',
      business_categories: ['kensetsu']
    },
    {
      title: '令和3年度福岡県農業振興対策事業費補助金（水田農業DX推進事業）',
      url: 'https://www.city.iizuka.lg.jp/norinnose/suidenndx.html',
      start_from: '2022-02-01',
      end_to: nil,
      ministry_name: '',
      prefecture_name: '福岡県',
      city_name: '飯塚市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '1/6',
      support_ratio_max: '1/3',
      level: nil,
      detail: 'ロボットコンバイン
      ロボットトラクター
      ロボット田植機
      農業用ドローン
      自動操舵システム
      水管理システム
      RTK基地局
      耕起や整地等、その他管理に必要な付属機械器具（ロボットコンバイン等の付属機械器具）
      上記は耐用年数が7年以上で50万円以上のものに限ります。',
      target_detail: '集落営農組織、農地所有適格法人、認定農業者、農業協同組合等',
      subsidy_category: 'hojo',
      supplier_type: 'city',
      business_categories: ['seizo', 'hotel_insyoku']
    },
    {
      title: 'start & category & tsukuba & prefecture',
      url: 'https://www.city.ihisjijiizuka.lg.jp/norinnose/suidenndx.html',
      start_from: '2022-02-03',
      end_to: nil,
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '1/6',
      support_ratio_max: '1/3',
      level: nil,
      detail: 'ロボットコンバイン
      ロボットトラクター
      ロボット田植機
      農業用ドローン
      自動操舵システム
      水管理システム
      RTK基地局
      耕起や整地等、その他管理に必要な付属機械器具（ロボットコンバイン等の付属機械器具）
      上記は耐用年数が7年以上で50万円以上のものに限ります。',
      target_detail: '集落営農組織、農地所有適格法人、認定農業者、農業協同組合等',
      subsidy_category: 'hojo',
      supplier_type: 'city',
      business_categories: ['seizo']
    },
    {
      title: 'start & category & tsukuba & prefecture',
      url: 'https://www.cidwdty.ihisjijiizuka.lg.jp/norinnose/suidenndx.html',
      start_from: '2022-02-05',
      end_to: nil,
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '1/6',
      support_ratio_max: '1/3',
      level: nil,
      detail: 'ロボットコンバイン
      ロボットトラクター
      ロボット田植機
      農業用ドローン
      自動操舵システム
      水管理システム
      RTK基地局
      耕起や整地等、その他管理に必要な付属機械器具（ロボットコンバイン等の付属機械器具）
      上記は耐用年数が7年以上で50万円以上のものに限ります。',
      target_detail: '集落営農組織、農地所有適格法人、認定農業者、農業協同組合等',
      subsidy_category: 'hojo',
      supplier_type: 'city',
      business_categories: ['kensetsu']
    },
    {
      title: 'start & category & prefecture ',
      url: 'https://www.city.ihisjiddfjiizuka.lg.jp/norinnose/suidenndx.html',
      start_from: '2022-02-7',
      end_to: nil,
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: '',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '1/6',
      support_ratio_max: '1/3',
      level: nil,
      detail: 'ロボットコンバイン
      ロボットトラクター
      ロボット田植機
      農業用ドローン
      自動操舵システム
      水管理システム
      RTK基地局
      耕起や整地等、その他管理に必要な付属機械器具（ロボットコンバイン等の付属機械器具）
      上記は耐用年数が7年以上で50万円以上のものに限ります。',
      target_detail: '集落営農組織、農地所有適格法人、認定農業者、農業協同組合等',
      subsidy_category: 'hojo',
      supplier_type: 'prefecture',
      business_categories: ['seizo']
    },
    {
      title: 'start & category',
      url: 'https://www.city.ihisjiddfjijjiizukdwa.lg.jp/norinnose/suidenndx.html',
      start_from: '2022-02-02',
      end_to: nil,
      ministry_name: '',
      prefecture_name: '大阪府',
      city_name: '河内長野市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '1/6',
      support_ratio_max: '1/3',
      level: nil,
      detail: 'ロボットコンバイン
      ロボットトラクター
      ロボット田植機
      農業用ドローン
      自動操舵システム
      水管理システム
      RTK基地局
      耕起や整地等、その他管理に必要な付属機械器具（ロボットコンバイン等の付属機械器具）
      上記は耐用年数が7年以上で50万円以上のものに限ります。',
      target_detail: '集落営農組織、農地所有適格法人、認定農業者、農業協同組合等',
      subsidy_category: 'hojo',
      supplier_type: 'city',
      business_categories: ['kensetsu']
    },
    {
      title: 'start',
      url: 'https://www.city.ihisjidiiidfjijjiizukdwa.lg.jp/norinnose/suidenndx.html',
      start_from: '2022-02-02',
      end_to: nil,
      ministry_name: '',
      prefecture_name: '大阪府',
      city_name: '河内長野市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '1/6',
      support_ratio_max: '1/3',
      level: nil,
      detail: 'ロボットコンバイン
      ロボットトラクター
      ロボット田植機
      農業用ドローン
      自動操舵システム
      水管理システム
      RTK基地局
      耕起や整地等、その他管理に必要な付属機械器具（ロボットコンバイン等の付属機械器具）
      上記は耐用年数が7年以上で50万円以上のものに限ります。',
      target_detail: '集落営農組織、農地所有適格法人、認定農業者、農業協同組合等',
      subsidy_category: 'hojo',
      supplier_type: 'city',
      business_categories: ['gyogyo']
    },
    {
      title: 'no-match',
      url: 'https://www.city.ihisjidiiidfjijjiizukdwa.lg.jp/norinnose/suidenndx.html',
      start_from: '2022-01-02',
      end_to: nil,
      ministry_name: '',
      prefecture_name: '大阪府',
      city_name: '河内長野市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '1/6',
      support_ratio_max: '1/3',
      level: nil,
      detail: 'ロボットコンバイン
      ロボットトラクター
      ロボット田植機
      農業用ドローン
      自動操舵システム
      水管理システム
      RTK基地局
      耕起や整地等、その他管理に必要な付属機械器具（ロボットコンバイン等の付属機械器具）
      上記は耐用年数が7年以上で50万円以上のものに限ります。',
      target_detail: '集落営農組織、農地所有適格法人、認定農業者、農業協同組合等',
      subsidy_category: 'hojo',
      supplier_type: 'city',
      business_categories: ['gyogyo']
    },
    {
      title: 'start & category & prefecture & hitachinaka',
      url: 'https://www.city.ihokisjiddfjiiihuhzuka.lg.jp/norinnose/suidenndx.html',
      start_from: '2022-02-07',
      end_to: nil,
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'ひたちなか市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '1/6',
      support_ratio_max: '1/3',
      level: nil,
      detail: 'ロボットコンバイン
      ロボットトラクター
      ロボット田植機
      農業用ドローン
      自動操舵システム
      水管理システム
      RTK基地局
      耕起や整地等、その他管理に必要な付属機械器具（ロボットコンバイン等の付属機械器具）
      上記は耐用年数が7年以上で50万円以上のものに限ります。',
      target_detail: '集落営農組織、農地所有適格法人、認定農業者、農業協同組合等',
      subsidy_category: 'hojo',
      supplier_type: 'city',
      business_categories: ['seizo'],
    },
  ]
  subsidy_hashes.each do |hash|
    subsidy = Subsidy.find_or_initialize_by(url: hash[:url])
    subsidy.subsidy_business_categories = hash[:business_categories].map do |category|
      subsidy.subsidy_business_categories.build(business_category: category)
    end
    subsidy.update!(
      title: hash[:title],
      ministry: ministries[hash[:ministry_name]],
      prefecture: prefectures[hash[:prefecture_name]],
      city: cities[hash[:city_name]],
      start_from: hash[:start_from],
      end_to: hash[:end_to],
      publishing_code: hash[:publishing_code],
      price_max: hash[:price_max],
      support_ratio_min: hash[:support_ratio_min],
      support_ratio_max: hash[:support_ratio_max],
      level: hash[:level],
      detail: hash[:detail],
      target_detail: hash[:target_detail],
      subsidy_category: hash[:subsidy_category],
      supplier_type: hash[:supplier_type]
    )
  end
  company_hashes = [
    {
      name: '池垣株式会社',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      adress: 'つくば市天久保3丁目12-34',
      capital: '200000',
      total_employee: '200',
      business_categories: ['seizo']
    },
    {
      name: '池垣物産',
      prefecture_name: '大阪府',
      city_name: '河内長野市',
      adress: '河内長野市南希望が丘30-203',
      capital: '20010',
      total_employee: '3',
      business_categories: ['gyogyo']
    },
    {
      name: 'IGnet',
      prefecture_name: '北海道',
      city_name: '千歳市',
      adress: '千歳市30-2',
      capital: '5040404',
      total_employee: '30',
      business_categories: ['seizo', 'hotel_insyoku']
    }
  ]
  company_hashes.each do |hash|
    company = Company.find_or_initialize_by(name: hash[:name])
    company.company_business_categories = hash[:business_categories].map do |category|
      company.company_business_categories.build(business_category: category)
    end
    company.update!(
      prefecture: prefectures[hash[:prefecture_name]],
      capital: hash[:capital],
      city: cities[hash[:city_name]],
      adress: hash[:adress],
      total_employee: hash[:total_employee],
    )
  end

  # README要参照!
  firebase_uid = ENV['FIREBASE_UID_FOR_DEBUG']
  firebase_user_email = ENV['FIREBASE_USER_EMAIL_FOR_DEBUG']
  if firebase_uid.present?
    user = User.find_or_initialize_by(firebase_uid: firebase_uid)
    user.update(
      company: Company.first,
      email: firebase_user_email,
      display_name: '田中太郎',
      account_role: 'admin'
    )
  end
end
