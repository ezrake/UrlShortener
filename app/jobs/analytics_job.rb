class AnalyticsJob < ApplicationJob
  queue_as :default

  def perform(**args)
    @url = args[:url]
    user_agent = args[:user_agent]

    begin
      click_stat = @url.click_stats.find_by!(user_agent: user_agent)
    rescue ActiveRecord::RecordNotFound
      click_stat = @url.click_stats.new(
        "user_agent": user_agent,
        "clicks": 1,
      )
      click_stat.save
    end

    click_stat.clicks = click_stat.clicks + 1
    click_stat.save
  end
end
