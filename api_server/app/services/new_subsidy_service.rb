require 'google/cloud/storage'
require 'csv'

class NewSubsidyService
  BUCKET_NAME = Settings.scraping_bucket

  def initialize(scraping_date)
    @scraping_date = scraping_date
  end

  def execute!
    ministry_ids = Ministry.index_by_url_domain
    prefecture_ids = Prefecture.index_by_url_domain
    city_ids = City.index_by_url_domain
    cities = City.all.includes(:prefecture).index_by(&:id)
    instances = new_url_hashes.map do |hash|
      hash[:ministry_id] = ministry_ids[hash[:source_url_domain]]
      hash[:prefecture_id] = prefecture_ids[hash[:source_url_domain]]
      city_id = city_ids[hash[:source_url_domain]]
      hash[:city_id] = city_id
      hash[:prefecture_id] = cities[city_id].prefecture.id if city_id.present?
      hash[:supplier_type] = detect_supplier_type(hash)
      hash[:created_at] = @scraping_date.to_time
      hash[:updated_at] = Time.now
      hash
    end
    SubsidyDraft.insert_all instances if instances.present?
  end

  def detect_supplier_type(hash)
    case
    when hash[:ministry_id].present?
      'ministry'
    when hash[:city_id].present?
      'city'
    when hash[:prefecture_id].present?
      'prefecture'
    end
  end

  def new_url_hashes
    existing_urls = SubsidyDraft.all.pluck(:url) + Subsidy.all.pluck(:url)
    hashes = files.map do |file|
      str = file.download
      csv_table = CSV.parse(str.read.force_encoding('UTF-8'), headers: true)
      csv_table.map do |table|
        next if existing_urls.include?(table['url'])

        uri = URI.parse(table['url'].gsub(/[[:space:]]/, ''))
        {
          source_url_domain: "#{uri.scheme}://#{uri.host}",
          title: table['text'].gsub(/[[:space:]]/, ''),
          url: table['url'].gsub(/[[:space:]]/, '')
        }
      rescue URI::InvalidURIError
        Rails.logger.error("invalid url #{table['url']}")
        next
      end.compact
    end
    hashes.flatten.uniq { |h| h[:url] }
  end

  private

  def storage
    if Rails.env.production?
      @storage ||= Google::Cloud::Storage.new
    else
      @storage ||= Google::Cloud::Storage.new(credentials: 'config/credentials/google.json')
    end
  end

  def bucket
    @bucket ||= storage.bucket(BUCKET_NAME)
  end

  def files
    # Cloud Storageには、日付毎に新着情報のcsvを格納している
    path = "daily/#{@scraping_date.year}/#{@scraping_date.month}/#{@scraping_date.day}"
    # スクレイピングのCloud Functionsでは並列処理でファイルが分割保存されているので、まとめてダウンロードする
    bucket.files(prefix: path)
  end

  def csv_to_hashes(csv_table)
    csv_table.map do |t|
      CSV_COLUMNS.map { |key, value| { value => t[key.to_s] } }.inject(&:merge)
    end
  end
end
