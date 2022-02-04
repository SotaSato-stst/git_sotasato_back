class CreateAccountService
  class SignUpError < StandardError; end
  URL = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp'.freeze
  FIREBASE_API_KEY = ENV['FIREBASE_API_KEY']

  def initialize(email)
    @params = {
      email: email,
      password: SecureRandom.hex(4)
    }
  end

  def execute!
    response = request
    json = JSON.parse(response.body)
    raise StandardError if response.code.to_i != 200

    json['localId']
  rescue StandardError
    raise SignUpError, json['error']['message']
  end

  def request
    uri = URI.parse(URL)
    uri.query = URI.encode_www_form({ key: FIREBASE_API_KEY })
    Net::HTTP.post_form(uri, @params)
  end
end
