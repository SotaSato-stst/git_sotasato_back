class OrganizationType
  class << self
    def all
      {
        kabu: '株式会社',
        godo: '合同・合名・合資会社',
        kojin: '個人事業主',
        iryo: '医療法人',
        npo: 'NPO法人'
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
