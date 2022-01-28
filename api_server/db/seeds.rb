require 'csv'

ActiveRecord::Base.logger = Logger.new($stdout)
Rails.logger.level = Logger::DEBUG

if Ministry.count.zero?
  CSV.open('db/seeds/ministries.csv', headers: true).to_a.each do |row|
    ministry = Ministry.find_or_initialize_by(name: row['name'])
    ministry.update(logo_url: row['logo_url'])
  end
end
if Prefecture.count.zero?
  CSV.open('db/seeds/prefectures.csv', headers: true).to_a.each do |row|
    prefecture = Prefecture.find_or_initialize_by(id: row['id'])
    prefecture.update(name: row['name'], logo_url: row['logo_url'] || '')
  end
end
if City.count.zero?
  CSV.open('db/seeds/cities.csv', headers: true).to_a.each do |row|
    city = City.find_or_initialize_by(name: row['name'])
    city.update(prefecture_id: row['prefecture_id'], logo_url: row['logo_url'] || '')
  end
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
      supplier_type: 'ministry'
    },
    {
      title: 'ものづくり補助金',
      url: 'https://portal.monodukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '厚生労働省',
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
      subsidy_category: 'josei',
      supplier_type: 'ministry'
    },
    {
      title: 'IT導入補助金',
      url: 'https://www.it-hojo.jp/applicant/',
      start_from: '2022-01-01',
      end_to: '2022-02-01',
      ministry_name: '農林水産省',
      publishing_code: 'published',
      price_max: '1073741824',
      support_ratio_min: '30',
      support_ratio_max: '80',
      level: '4',
      detail: '飲食業等緊急支援給付金のお知らせ
      新型コロナの影響により厳しい経営環境にある夜間営業の飲食店等が、年末の需要減を乗り越えて事業継続できるよう、県独自の給付金を給付します。

      自社の置かれた環境から強み・弱みを認識、分析し、把握した経営課題や需要に合ったITツールを導入することで、業務効率化・売上アップといった経営力の向上・強化を図っていただくことを目的としています。',
      target_detail: '令和３年１０月・１１月・１２月のいずれかの売上が、前年同月又は前々年同月と比較して３０％以上減少した、県内で次の事業を営む方

      〇酒類を提供し夜９時以降も営業している飲食店（持ち帰り・配達サービス業は対象外）
      〇カラオケボックス業（飲食を提供している事業者のみ対象）
      〇酒類卸売業（飲食店に対し、酒類を販売する事業者のみ対象）
      〇洗濯業（飲食店に対し、おしぼりをレンタル・リースしている事業者のみ対象）
      〇労働者派遣業（飲食店に対し、芸妓、コンパニオン等を派遣する事業者のみ対象）
      〇運転代行業',
      subsidy_category: 'hojo',
      supplier_type: 'ministry'
    },
    {
      title: '事業復活支援金',
      url: 'https://www.city.toride.ibaraki.jp/sanshin/jigyosha/shokogyo/hojokin/jigyouhukkatusiennkinn.html',
      start_from: '2022-05-01',
      end_to: '2022-12-01',
      ministry_name: '総務省',
      publishing_code: 'published',
      price_max: '15731824',
      support_ratio_min: '30',
      support_ratio_max: '40',
      level: '5',
      detail: '飲食業等緊急支援給付金のお知らせ
      新型コロナの影響により厳しい経営環境にある夜間営業の飲食店等が、年末の需要減を乗り越えて事業継続できるよう、県独自の給付金を給付します。

      自社の置かれた環境から強み・弱みを認識、分析し、把握した経営課題や需要に合ったITツールを導入することで、業務効率化・売上アップといった経営力の向上・強化を図っていただくことを目的としています。',
      target_detail: '2021年11月から2022年3月のいずれかの月の売上高が2018年11月から2021年3月までの間の任意の同じ月の売上高と比較して50％以上または30％以上50％未満減少した事業者（中堅、中小、小規模事業者、フリーランスを含む個人事業者）',
      subsidy_category: 'josei',
      supplier_type: 'ministry',
    },
    {
      title: '事業復活支援金',
      url: 'https://www.pref.hokkaido.lg.jp/kz/csk/syuruitokubetsushienkin.html',
      start_from: '2022-05-01',
      end_to: '2022-12-01',
      city_name: '夕張市',
      publishing_code: 'published',
      price_max: '15731824',
      support_ratio_min: '30',
      support_ratio_max: '40',
      level: '5',
      detail: '飲食業等緊急支援給付金のお知らせ
      新型コロナの影響により厳しい経営環境にある夜間営業の飲食店等が、年末の需要減を乗り越えて事業継続できるよう、県独自の給付金を給付します。

      自社の置かれた環境から強み・弱みを認識、分析し、把握した経営課題や需要に合ったITツールを導入することで、業務効率化・売上アップといった経営力の向上・強化を図っていただくことを目的としています。',
      target_detail: '2021年11月から2022年3月のいずれかの月の売上高が2018年11月から2021年3月までの間の任意の同じ月の売上高と比較して50％以上または30％以上50％未満減少した事業者（中堅、中小、小規模事業者、フリーランスを含む個人事業者）',
      subsidy_category: 'hojo',
      supplier_type: 'city',
    },
    {
      title: 'ものづくり補助金',
      url: 'https://www.town.kanra.lg.jp/kenkou/fukusi/news/20210531101859.html',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '三笠市',
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
      subsidy_category: 'josei',
      supplier_type: 'prefecture'
    },
    {
      title: 'ものづくる補助金',
      url: 'https://www.town.kajiijinra.lg.jp/kenkou/fukusi/news/20210531101859.html',
      start_from: '2022/1/12',
      end_to: '',
      ministry_name: '三笠市',
      publishing_code: 'published',
      price_max: '',
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
      supplier_type: 'city'
    },
    {
      title: 'ものづくる補助金',
      url: 'https://www.town.kajifjidjiijinra.lg.jp/kenkou/fukusi/news/20210531101859.html',
      start_from: '2022/1/12',
      end_to: nil,
      ministry_name: '三笠市',
      publishing_code: 'published',
      price_max: nil,
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
      supplier_type: 'prefecture'
    },
    {
      title: 'テスト補助金',
      url: 'https://www.town.kajiedeifjidjiijinra.lg.jp/kenkou/fukusi/news/20210531101859.html',
      start_from: '2022/1/12',
      end_to: nil,
      ministry_name: '三笠市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '30',
      support_ratio_max: '80',
      level: nil,
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
      subsidy_category: 'josei',
      supplier_type: 'prefecture'
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
      target_detail: hash[:target_detail],
      subsidy_category: hash[:subsidy_category],
      supplier_type: hash[:supplier_type]
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
      business_scale: 'large',
      business_categories: ['seizo']
    },
    {
      name: '池垣物産',
      prefecture_name: '神奈川県',
      city_id: '2',
      adress: '河内長野市南希望が丘30-203',
      capital: '20010',
      total_employee: '3',
      business_scale: 'small_business',
      business_categories: ['gyogyo']
    },
    {
      name: 'IGnet',
      prefecture_name: '香川県',
      city_id: '3',
      adress: '千歳市30-2',
      capital: '5040404',
      total_employee: '30',
      business_scale: 'small_business',
      business_categories: ['seizo', 'hotel_insyoku']
    }
  ]
  prefectures = Prefecture.all.index_by(&:name)
  company_hashes.each do |hash|
    company = Company.find_or_initialize_by(name: hash[:name])
    company.business_categories = hash[:business_categories].map do |category|
      company.business_categories.build(business_category: category)
    end
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
