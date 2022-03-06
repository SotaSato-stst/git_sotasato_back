class BusinessCategory
  class << self
    def all
      {
        seizo: '製造業',
        kensetsu: '建設業',
        it: '情報通信業（IT）',
        syukuhaku: '宿泊業',
        insyoku: '飲食サービス業',
        seikatsu: '生活関連サービス業',
        goraku: '娯楽業',
        oroshi: '卸売業,小売業',
        unnyu: '運輸業,郵便業',
        kinnyu: '金融業,保険業',
        hudosan: '不動産業,物品賃貸業',
        kenkyu: '学術研究,専門・技術サービス業',
        nogyo: '農業',
        ringyo: '林業',
        gyogyo: '漁業',
        infra: '電気・ガス・熱供給・水道業',
        kogyo: '鉱業,採石業,砂利採取業',
        kyoiku: '教育,学習支援業',
        iryo: '医療',
        fukushi: '福祉',
        komu: '公務'
      }
    end

    def enum_hash
      all.keys.map(&:to_s).map { |k| { k => k } }.inject(&:merge)
    end

    def to_options
      all.map { |key, name| { key: key, name: name } }
    end

    def to_option(key)
      { key: key.to_s, name: all[key.to_sym] }
    end
  end
end
