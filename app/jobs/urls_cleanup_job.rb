class UrlsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Url.destroy_by("expires_at > ?", "#{Time.now}")
  end
end
