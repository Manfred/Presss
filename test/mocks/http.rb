module Net
  class FakeHTTP
    class Response
      attr_accessor :code, :body

      def initialize(code, header=nil, body=nil)
        @code, @header, @body = code, header, body
      end
    end

    class << self
      attr_accessor :requests, :next_response
    end
    self.requests = []

    def request(request)
      self.class.requests << request
    end

    def response
      self.class.next_response || Net::FakeHTTP::Response.new(200, {}, nil)
    end
  end

  class HTTP
    def start(&block)
      http = Net::FakeHTTP.new
      block.call(http)
      http.response
    end
  end
end