module Providers
  module Raindrop
    class Error < StandardError; end

    class Unauthorized < Error; end
    class RateLimited < Error; end
    class ApiError < Error; end
  end
end
