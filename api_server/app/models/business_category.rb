class BusinessCategory
  class << self
    def all # rubocop:disable Metrics/MethodLength
      {
        rinnou: '農業, 林業',
        gyogyo: '漁業',
        kogyo: '鉱業, 採石業, 砂利採取業',
        kensetsu: '建設業',
        seizo: '製造業',
        infra: '電気・ガス・熱供給・水道業',
        it: '情報通信業',
        unnyu: '運輸業, 郵便業',
        kouri: '卸売業, 小売業',
        kinnyu: '金融業, 保険業',
        fudosan: '不動産業, 物品賃貸業',
        kenkyu: '学術研究, 専門・技術サービス業',
        hotel_insyoku: '宿泊業, 飲食サービス業',
        goraku: '生活関連サービス業, 娯楽業',
        kyoiku: '教育, 学習支援業',
        iryo: '医療, 福祉',
        fukugo: '複合サービス事業',
        service: 'サービス業（他に分類されないもの）',
        koumu: '公務（他に分類されるものを除く）',
        other: '分類不能の産業'
      }
    end

    def enum_hash
      all.keys.map(&:to_s).map { |k| { k => k } }.inject(&:merge)
    end

    def to_options
      all.map { |key, name| { key: key, name: name } }
    end
  end
end
