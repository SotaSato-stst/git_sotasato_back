class OrganizationType
  class << self
    def all
      {
        kabu: '株式会社',
        godo: '合同・合名・合資会社',
        kojin: '個人事業主',
        bengo: '弁護士法人',
        kansa: '監査法人',
        zeiri: '税理士法人',
        gyosei: '行政書士法人',
        shiho: '司法書士法人',
        tokkyo: '特許業務法人',
        sharoshi: '社会保険労務士法人',
        iryo: '医療法人',
        gakko: '学校法人',
        npo: 'NPO法人',
        syukyo: '宗教法人'
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
