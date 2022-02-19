class FirebaseAccountService
  class AccountError < StandardError; end

  FIREBASE_API_KEY = Settings.firebaes_api_key
  SIGNUP_URL = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp'.freeze
  DELETE_URL = 'https://identitytoolkit.googleapis.com/v1/accounts:delete'.freeze

  def sign_up!(email)
    params = {
      email: email,
      password: SecureRandom.hex(4)
    }
    post(SIGNUP_URL, params)
    @response_json['localId'] # firebase_uid
  rescue StandardError
    raise AccountError, @response_json['error']['message']
  end

  def delete!(firebase_uid)
    post(DELETE_URL, { idToken: firebase_uid })
    true
  rescue StandardError
    raise AccountError, @response_json['error']['message']
  end

  private

  def post(url, params = nil)
    uri = URI.parse(url)
    uri.query = URI.encode_www_form({ key: FIREBASE_API_KEY })
    response = Net::HTTP.post_form(uri, params)
    @response_json = JSON.parse(response.body)
    raise StandardError if response.code.to_i != 200

    response
  end
end
