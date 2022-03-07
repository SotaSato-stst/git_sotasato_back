require 'csv'

if Ministry.count.zero?
  instances = CSV.open('db/seeds/ministries.csv', headers: true).to_a.map do |row|
    {
      name: row['name'],
      logo_url: row['logo_url'],
      url_domain: row['url_domain'] || '',
      created_at: Time.now,
      updated_at: Time.now
    }
  end
  Ministry.insert_all instances
end
if Prefecture.count.zero?
  instances = CSV.open('db/seeds/prefectures.csv', headers: true).to_a.map do |row|
    {
      id: row['id'],
      name: row['name'],
      logo_url: row['logo_url'] || '',
      url_domain: row['url_domain'] || '',
      created_at: Time.now,
      updated_at: Time.now
    }
  end
  Prefecture.insert_all instances
end
if City.count.zero?
  instances = CSV.open('db/seeds/cities.csv', headers: true).to_a.map do |row|
    {
      name: row['name'],
      prefecture_id: row['prefecture_id'],
      logo_url: row['logo_url'] || '',
      url_domain: row['url_domain'] || '',
      created_at: Time.now,
      updated_at: Time.now
    }
  end
  City.insert_all instances
end

# 開発用のテストデータ
if Rails.env.development?
  ministries = Ministry.all.index_by(&:name)
  prefectures = Prefecture.all.index_by(&:name)
  cities = City.all.index_by(&:name)

  subsidy_hashes = [
    {
      title: 'ものづくり補助金',
      url: 'https://portal.monodukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '経済産業省',
      prefecture_name: '',
      city_name: '',
      publishing_code: 'published',
      price_max: 10000000,
      support_ratio_min: nil,
      support_ratio_max: '1/2',
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
      ranking_score: 50,
      capital_max: nil,
      capital_min: nil,
      total_employee_max: 20000,
      total_employee_min: nil,
      business_categories: ['it'],
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '設備投資を応援！',
      keywords: ['多種多様なシステム構築費', '農業ハウス設備', '自動チェックイン機', 'レーザーカッター', '設備導入'],
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
      ranking_score: 50,
      capital_max: 5000000,
      capital_min:100000,
      total_employee_max: 200,
      total_employee_min: 50,
      business_categories: ['syukuhaku'],
      annual_sales_max: nil, 
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '',
      keywords: ['中小企業', 'コロナ関連', 'ホテル'],
    },
    {
      title: 'AI・IoT等を活用した更なる輸送効率化推進事業費補助金の公募',
      url: 'https://www.enecho.meti.go.jp/appli/public_offer/2021/20220121_001.html',
      start_from: '2022-01-21',
      end_to: '2022-02-21',
      ministry_name: '経済産業省',
      prefecture_name: '',
      city_name: '',
      publishing_code: 'published',
      price_max: 500000000,
      support_ratio_min: '',
      support_ratio_max: '1/2',
      level: 2,
      detail: '本事業は、民間団体等が行う、運航計画・配船計画・RORO船等荷役の最適化等のソフト面の対策や、当該対策を前提とした省エネルギー船型、高効率推進システム（バッテリー推進のものを含む。）、荷役効率化設備（スマート電動ウインチ、荷役設備向け陸上電力受電設備等）等のハード面の対策の導入による輸送全体の最適化を目指した実証事業（後年度事業を含む。）の実施に要する経費を補助することにより、海上輸送部門における省エネルギーを推進し、もって、内外の経済的社会的環境に応じた安定的かつ適切なエネルギーの需給構造の構築を図るものです。',
      target_detail: '補助対象事業
      本事業は、上記１．の目的を達成するため、内航海運における配船計画最適化等の陸側と
      の連携を含む運航ルートやスケジュールの最適化、高効率推進システムの最適な運用方法の
      確立、RORO船等の荷役最適化システム等のソフト面の対策、当該対策を前提とした省エネル
      ギー船型、高効率推進システム（バッテリー推進のものを含む。）、荷役効率化設備（スマ
      ート電動ウインチ、荷役設備向け陸上電力受電設備等）等のハード面の対策の導入による輸
      送全体の最適化を目指した実証事業を対象とします。具体的には、以下の要件を満たす必要
      があります。
      ① 補助事業に係る船舶について、ソフト面とハード面を組み合わせた省エネ対策の導入に
      よって、比較対象船舶（補助事業に係る船舶と大きさ、船種、航路その他主要目が可能
      な限り類似しているもの、原則として 2000 年代に建造されたもの）からエネルギー消
      費削減率が１％以上見込まれること。
      ② 比較対象船舶及び補助事業に係る船舶の運航データを提供すること。
      ③ 補助事業に係る船舶について、｢内航船省エネルギー格付制度※1
      ｣に定める格付けを取得
      すること。
      申請資格
      申請にあたっては、次の①～⑤までの全ての条件を満たすことが必要です。
      ① 本邦の内航海運事業者等※2であって、補助事業に係る船舶の所有者（船舶所有者になる
      ことを予定している者を含む。以下同じ。）であること。ただし、内航海運事業者等※2
      が船舶を所有している事業者と共同で申請する場合も条件を満たすものとします。
      ② 補助事業を的確に遂行する組織、人員等を有していること。
      ③ 補助事業を円滑に遂行するために必要な経営基盤を有し、かつ、資金等について十分な
      管理能力を有していること。
      3
      ④ 経済産業省からの補助金交付等停止措置又は指名停止措置が講じられている者ではな
      いこと。
      ⑤ 「暴力団排除に関する誓約事項」に記載されている事項に該当しないこと（誓約事項に
      違反した場合、交付決定の全部又は一部を取り消すことに留意すること）。',
      subsidy_category: 'hojo',
      supplier_type: 'ministry',
      ranking_score: 80,
      capital_max: nil,
      capital_min: nil,
      business_categories: ['unnyu', 'it'],
      total_employee_max: nil,
      total_employee_min: nil,
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '海上輸送部門における省エネルギーを推進し輸送全体の最適化を図る公募！',
      keywords: ['海上輸送', 'エネルギー', 'AI'],
    },
    {
      title: '事業復活支援金',
      url: 'https://jigyou-fukkatsu.go.jp/index.html',
      start_from: '2022-01-31',
      end_to: '2022-05-31',
      ministry_name: '中小企業庁',
      prefecture_name: '',
      city_name: '',
      publishing_code: 'published',
      price_max: 2500000,
      support_ratio_min: '',
      support_ratio_max: '',
      level: 4,
      detail: '中小企業庁では、新型コロナウイルス感染症の拡大や長期化に伴う需要の減少又は供給の制約により大きな影響を受け、自らの事業判断によらずに売上が大きく減少している中堅企業、中小法人及び個人事業者に対して、事業の継続・回復を支援する事業復活支援金の申請受付を１月３１日（月）より行っています。',
      target_detail: '　下記(1)、(2)を満たす中小法人・個人事業者
      　　(1)新型コロナウイルス感染症の影響を受けた事業者
      　　(2)2021年11月～2022年3月のいずれかの月（対象月）の売上高が、
      　　　 2018年11月～2021年3月の間の任意の同じ月（基準月）の売上高と比較し
      　　　 50%以上又は30%以上50%未満減少した事業者',
      subsidy_category: 'hojo',
      supplier_type: 'ministry',
      ranking_score: 85,
      capital_max: nil,
      capital_min:nil,
      business_categories: ['komu'],
      total_employee_max: nil,
      total_employee_min: nil,
      annual_sales_max: nil, 
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: 'コロナの影響を受けた全ての中小法人・個人事業者が給付対象です！',
      keywords: ['中小企業', 'コロナ関連'],
    },
    {
      title: '中小企業災害対応力強化支援補助金',
      url: 'https://www.pref.tottori.lg.jp/280764.htm',
      start_from: '2021-05-10',
      end_to: nil,
      ministry_name: '',
      prefecture_name: '鳥取県',
      city_name: '',
      publishing_code: 'published',
      price_max: 1000000,
      support_ratio_min: '',
      support_ratio_max: '1/2',
      level: 4,
      detail: 'この補助金は、県内の中小企業者等が事業継続計画（以下「ＢＣＰ」という。）の策定並びにその実効性向上のためのＢＣＰの改善及び必要な防災措置に要する経費を支援し、もって県内中小企業等の災害対応力の強化を図ることを目的とします。',
      target_detail: ' 防災措置型	
      ＢＣＰを策定し、又は 策定しようとする県内の 中小企業者等のうち、県内に所在する事業所におけるＢＣＰの実効性の向上や災害対応力の強化のため必要な防災措置を行おうとする方
      地域連携型	 ＢＣＰにおいて地域住民の安心・安全に資する活動等を定めている県内の中小企業者等で、自治会・町内会等と当該活動にかかる協定等を締結している方
      ＢＣＰ策定・改善型	県内の 中小企業者等のうち、ＢＣＰの策定又は改善を行おうとする方',
      subsidy_category: 'hojo',
      supplier_type: 'prefecture',
      ranking_score: 20,
      capital_max: nil,
      capital_min:nil,
      business_categories: ['kogyo'],
      total_employee_max: nil,
      total_employee_min: nil,
      annual_sales_max: nil, 
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '',
      keywords: [],
    },
    {
      title: '全て揃ってる',
      url: 'https://porfghjtal.monojdukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: 15000000,
      support_ratio_min: '1/4',
      support_ratio_max: '1/2',
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
      supplier_type: 'city',
      ranking_score: 50,
      capital_max: nil,
      capital_min: nil,
      total_employee_max: nil,
      total_employee_min: nil,
      business_categories: ['seizo'],
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '設備投資を応援！',
      keywords: ['多種多様なシステム構築費', '農業ハウス設備', '自動チェックイン機', 'レーザーカッター', '設備導入'],
    },
    {
      title: '補助割合がない',
      url: 'https://porjtal.monojdukuruhi-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: 15000000,
      support_ratio_min: '',
      support_ratio_max: '',
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
      supplier_type: 'city',
      ranking_score: 50,
      capital_max: nil,
      capital_min: nil,
      total_employee_max: nil,
      total_employee_min: nil,
      business_categories: ['seizo'],
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '設備投資を応援！',
      keywords: ['多種多様なシステム構築費', '農業ハウス設備', '自動チェックイン機', 'レーザーカッター', '設備導入'],
    },
    {
      title: '上限金額がない',
      url: 'https://porjlltal.monojjdukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '1/4',
      support_ratio_max: '1/2',
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
      supplier_type: 'city',
      ranking_score: 50,
      capital_max: nil,
      capital_min: nil,
      total_employee_max: nil,
      total_employee_min: nil,
      business_categories: ['seizo'],
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '設備投資を応援！',
      keywords: ['多種多様なシステム構築費', '農業ハウス設備', '自動チェックイン機', 'レーザーカッター', '設備導入'],
    },
    {
      title: '上限金額と補助割合がない',
      url: 'https://porjtal.mhhonijiojdukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: '',
      support_ratio_max: '',
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
      supplier_type: 'city',
      ranking_score: 50,
      capital_max: nil,
      capital_min: nil,
      total_employee_max: nil,
      total_employee_min: nil,
      business_categories: ['seizo'],
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '設備投資を応援！',
      keywords: ['多種多様なシステム構築費', '農業ハウス設備', '自動チェックイン機', 'レーザーカッター', '設備導入'],
    },
    {
      title: '募集期間がない',
      url: 'https://portahl.mohhnojdukuri-hojo.jp/',
      start_from: nil,
      end_to: nil,
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: 15000000,
      support_ratio_min: '1/4',
      support_ratio_max: '1/2',
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
      supplier_type: 'city',
      ranking_score: 50,
      capital_max: nil,
      capital_min: nil,
      total_employee_max: nil,
      total_employee_min: nil,
      business_categories: ['seizo'],
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '設備投資を応援！',
      keywords: ['多種多様なシステム構築費', '農業ハウス設備', '自動チェックイン機', 'レーザーカッター', '設備導入', '金属バット', 'ICT導入', 'ドローン機器等'],
    },
    {
      title: 'キャッチコピーがない',
      url: 'https://portahl.monojdukujijiiiiri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: 15000000,
      support_ratio_min: '1/4',
      support_ratio_max: '1/2',
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
      supplier_type: 'city',
      ranking_score: 50,
      capital_max: nil,
      capital_min: nil,
      total_employee_max: nil,
      total_employee_min: nil,
      business_categories: ['seizo'],
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '',
      keywords: ['多種多様なシステム構築費', '農業ハウス設備', '自動チェックイン機', 'レーザーカッター', '設備導入'],
    },
    {
      title: 'キーワードがない',
      url: 'https://portahl.monhhojdukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: 15000000,
      support_ratio_min: '1/4',
      support_ratio_max: '1/2',
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
      supplier_type: 'city',
      ranking_score: 50,
      capital_max: nil,
      capital_min: nil,
      total_employee_max: nil,
      total_employee_min: nil,
      business_categories: ['seizo'],
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '設備投資を応援！',
      keywords: [],
    },
    {
      title: '上限金額・支援割合・キーワード・キャッチコピーがない',
      url: 'https://pojijijijhirtahl.mosdfghjnhhojdukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: nil,
      support_ratio_min: nil,
      support_ratio_max: nil,
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
      supplier_type: 'city',
      ranking_score: 50,
      capital_max: nil,
      capital_min: nil,
      total_employee_max: nil,
      total_employee_min: nil,
      business_categories: ['seizo'],
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '',
      keywords: [],
    },
    {
      title: 'タイトルが長いタイトルが長いタイトルが長いタイトルが長いタイトルが長いタイトルが長いタイトルが長いタイトルが長いタイトルが長い',
      url: 'https://pojijijijhirtahl.monhhojdukuri-hojo.jp/',
      start_from: '2022/1/12',
      end_to: '2023/1/15',
      ministry_name: '',
      prefecture_name: '茨城県',
      city_name: 'つくば市',
      publishing_code: 'published',
      price_max: 15000000,
      support_ratio_min: '1/4',
      support_ratio_max: '1/2',
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
      supplier_type: 'city',
      ranking_score: 50,
      capital_max: nil,
      capital_min: nil,
      total_employee_max: nil,
      total_employee_min: nil,
      business_categories: ['seizo'],
      annual_sales_max: nil,
      annual_sales_min: nil,
      years_of_establishment: nil,
      catch_copy: '設備投資を応援！',
      keywords: ['多種多様なシステム構築費', '農業ハウス設備', '自動チェックイン機', 'レーザーカッター', '設備導入'],
    },
  ]
  subsidy_hashes.each do |hash|
    subsidy = Subsidy.find_or_initialize_by(url: hash[:url])
    subsidy.subsidy_business_categories = hash[:business_categories].map do |category|
      subsidy.subsidy_business_categories.build(business_category: category)
    end

    subsidy.subsidy_keywords = hash[:keywords].to_a.map do |content|
      keyword = Keyword.create_or_find_by(content: content)
      subsidy.subsidy_keywords.build(keyword: keyword)
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
      supplier_type: hash[:supplier_type],
      ranking_score: hash[:ranking_score],
      total_employee_max: hash[:total_employee_max],
      total_employee_min: hash[:total_employee_min],
      annual_sales_min: hash[:annual_sales_min],
      annual_sales_max: hash[:annual_sales_max],
      years_of_establishment: hash[:years_of_establishment],
      catch_copy: hash[:catch_copy],
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
      business_categories: ['seizo']
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
