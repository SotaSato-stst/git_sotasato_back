require 'google/cloud/storage'
require 'csv'

class NewSubsidyService
  BUCKET_NAME = ENV['NEW_SUBSIDY_BUCKET']

  def initialize(scraping_date)
    @scraping_date = scraping_date
  end

  def execute!
    ministries = Ministry.index_by_url_domain
    prefectures = Prefecture.index_by_url_domain
    cities = City.index_by_url_domain
    instances = new_url_hashes.map do |hash|
      hash[:ministry_id] = ministries[hash[:source_url_domain]]
      hash[:prefecture_id] = prefectures[hash[:source_url_domain]]
      hash[:city_id] = cities[hash[:source_url_domain]]
      hash[:created_at] = Time.now
      hash[:updated_at] = Time.now
      hash
    end
    SubsidyDraft.insert_all instances
  end

  def new_url_hashes
    files.map do |file|
      str = file.download
      csv_table = CSV.parse(str.read.force_encoding('UTF-8'), headers: true)
      csv_table.map do |table|
        uri = URI.parse(table['target_url'])
        {
          source_url_domain: "#{uri.scheme}://#{uri.host}",
          title: table['text'],
          url: table['url']
        }
      end
    end.flatten
  end

  private

  def storage
    @storage ||= Google::Cloud::Storage.new(credentials: 'config/credentials/google.json')
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
