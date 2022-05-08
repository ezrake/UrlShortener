class ShortUrlsGeneratorJob < ApplicationJob
  require "securerandom"
  queue_as :default

  def perform(**args)
    short_urls = []
    args[:amount].times do
      short_urls.push SecureRandom.alphanumeric 8
    end
    redis = args[:redis]
    redis.lpush args[:list], short_urls
    redis.close
  end
end
