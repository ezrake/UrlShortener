class Api::V1::UrlsController < Api::V1::BaseController
  before_action :enough_short_urls, only: [:create]

  SHORT_URL_LIST = "short_urls"
  MIN_UNIQUE_IDS = 500

  def create
    if !params[:short_url].empty?
      short_url = params[:short_url]
    else
      while true
        short_url = fetch_redis_shorturl
        break if !Url.find_by(short_url: short_url)
      end
    end

    full_url = request.base_url + "/" + short_url
    @url = Url.new(
      short_url: short_url,
      long_url: params[:long_url],
      full_url: full_url,
    )

    if @url.save
      render json: @url, status: :created
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  def long_url_redirect
    begin
      @url = Url.find_by!(short_url: params[:short_url])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found and return
    end

    AnalyticsJob.perform_later(
      user_agent: request.headers["User-Agent"],
      url: @url,
    )

    redirect_to @url.long_url, allow_other_host: true
  end

  private

  def fetch_redis_shorturl
    REDIS.brpop(SHORT_URL_LIST)[1]
  end

  def enough_short_urls
    len = REDIS.llen(SHORT_URL_LIST)
    if len < MIN_UNIQUE_IDS
      amount = (MIN_UNIQUE_IDS - len) * 2
      ShortUrlsGeneratorJob.perform_now(
        redis: REDIS,
        list: SHORT_URL_LIST,
        amount: amount,
      )
    end
  end

  def url_params
    params.require(:long_url).permit(:long_url, :short_url)
  end
end
