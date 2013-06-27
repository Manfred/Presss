require 'openssl'
require 'base64'

class Presss
  class Authorization
    attr_accessor :access_key_id, :secret_access_key

    def initialize(access_key_id, secret_access_key)
      @access_key_id, @secret_access_key = access_key_id, secret_access_key
    end

    def header(string)
      'AWS ' + access_key_id + ':' + sign(string)
    end

    def sign(string)
      Base64.encode64(hmac_sha1(string)).strip
    end

    def hmac_sha1(string)
      OpenSSL::HMAC.digest('sha1', secret_access_key, string)
    end
  end
end