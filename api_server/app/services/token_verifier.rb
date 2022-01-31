require 'net/http'

# JWTの仕組みを使って、フロントのfirebase sdkから送られてきたJWTを照合する
# https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library
# https://github.com/jwt/ruby-jwt

class TokenVerifier
  class InvalidTokenError < StandardError; end
  GOOGLE_TOKEN_URL = 'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'.freeze
  FIREBASE_PROJECT_ID = ENV['FIREBASE_PROJECT_ID']

  def initialize(token)
    raise InvalidTokenError if token.blank?

    @token = token
  end

  def execute
    response_json.each do |kid, public_key|
      cert = OpenSSL::X509::Certificate.new(public_key)
      jwt = JWT.decode(@token, cert.public_key, true, option)

      return jwt[0]['user_id'] # firebaseのuid
    rescue OpenSSL::X509::CertificateError, JWT::DecodeError => e
      next
    end

    raise InvalidTokenError
  end

  def option
    {
      aud: FIREBASE_PROJECT_ID,
      verify_aud: true,
      iss: "https://securetoken.google.com/#{FIREBASE_PROJECT_ID}",
      verify_iss: true,
      algorithm: 'RS256'
    }
  end

  def response_json
    uri = URI.parse(GOOGLE_TOKEN_URL)
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body)
  end
end
