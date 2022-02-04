class DeleteAccountService
  class DeleteError < StandardError; end
  URL = 'https://identitytoolkit.googleapis.com/v1/accounts:delete'.freeze
  FIREBASE_API_KEY = ENV['FIREBASE_API_KEY']

  def initialize(firebase_uid)
    @params = {
      idToken: firebase_uid
    }
  end

  def execute!
    request
    true
  rescue StandardError
    raise DeleteError
  end

  def request
    uri = URI.parse(URL)
    uri.query = URI.encode_www_form({ key: FIREBASE_API_KEY })
    Net::HTTP.post_form(uri, @params)
  end
end
