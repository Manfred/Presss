require 'time'
require 'net/http'
require 'digest/md5'
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

  class HTTP
    class RequestError < StandardError; end

    class Response
      attr_accessor :status_code, :headers, :body

      def initialize(status_code, headers, body=nil)
        @status_code, @headers, @body = status_code.to_i, headers, body
      end

      # Returns _true_ when the status code is in the 2XX range. Returns false otherwise.
      def success?
        status_code >= 200 && status_code < 300
      end
    end

    class << self
      attr_accessor :host, :port
    end
    self.host = 's3-external-3.amazonaws.com'
    self.port = 443

    attr_accessor :config

    def initialize(config)
      @config = config
    end

    def bucket_name
      config[:bucket_name]
    end

    def host
      bucket_name + '.' + self.class.host
    end

    def absolute_path(path)
      path.start_with?('/') ? path : '/' + path
    end

    def canonicalized_resource(absolute_path)
      if bucket_name.nil?
        raise ArgumentError, "Please configure a bucket_name: Presss.config = { bucket_name: 'my-bucket-name }"
      else
        '/' + bucket_name + absolute_path
      end
    end

    def authorization
      @authorization ||= Presss::Authorization.new(
        config[:access_key_id],
        config[:secret_access_key]
      )
    end

    def headers(date, message, content_type=nil)
      headers = {
        'Authorization' => authorization.header(message),
        'Date' => date
      }
      if content_type
        headers['Content-Type'] = content_type
      end
      headers
    end

    def http
      @http ||= begin
        http = Net::HTTP.new(host, self.class.port)
        http.use_ssl = true
        http.ca_file = File.expand_path('../../../support/cacert.pem', __FILE__)
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http
      end
    end

    def join(verb, body, content_type, date, headers, absolute_path)
      [
        verb.to_s.upcase,
        nil,
        content_type,
        date,
        # TODO: aws-x headers?
        canonicalized_resource(absolute_path)
      ].join("\n")
    end

    def get(path)
      path = absolute_path(path)
      date = Time.now.rfc2822
      message = join('GET', nil, nil, date, nil, path)
      request = Net::HTTP::Get.new(path, headers(date, message))
      begin
        response = http.start { |http| http.request(request) }
        Presss::HTTP::Response.new(
          response.code,
          response.instance_variable_get('@header'),
          response.body
        )
      rescue EOFError => error
        raise Presss::HTTP::RequestError, error.message
      end
    end

    def put(path, file, content_type='application/x-download')
      path = absolute_path(path)
      body = file.respond_to?(:read) ? file.read : file.to_s
      date = Time.now.rfc2822
      message = join('PUT', body, content_type, date, nil, path)
      request = Net::HTTP::Put.new(path, headers(date, message, content_type))
      request.body = body
      begin
        response = http.start { |http| http.request(request) }
        Presss::HTTP::Response.new(
          response.code,
          response.instance_variable_get('@header'),
          response.body
        )
      rescue EOFError => error
        raise Presss::HTTP::RequestError, error.message
      end
    end
  end

  class << self
    attr_accessor :config
  end
  self.config = {}

  def self.get(path)
    request = Presss::HTTP.new(config)
    response = request.get(path)
    response.body
  end

  def self.put(path, file)
    request = Presss::HTTP.new(config)
    response = request.put(path, file)
    response.success?
  end
end
