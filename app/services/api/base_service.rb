module Api
  class BaseService
    def initialize
    end

    def handle_response(response)
      case response.code
      when 200..299
        JSON.parse(response.body)
      when 400..499
        raise "Client error: #{response.code} - #{response.body}"
      when 500..599
        raise "Server error: #{response.code} - #{response.body}"
      else
        raise "Unknown error: #{response.code} - #{response.body}"
      end
    end
  end
end
