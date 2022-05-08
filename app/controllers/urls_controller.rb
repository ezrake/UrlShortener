class UrlsController < ApplicationController
  before_action :enough_short_urls, only: [:create]

  SHORT_URL_LIST = "short_urls"
  MIN_UNIQUE_IDS = 500

  def create
    if params.has_key?(:short_url)
      short_url = params[:short_url]
      render status: 409 if !Url.find_by(short_url: short_url)
    else
      while true
        short_url = fetch_redis_shorturl
        break if !Url.find_by(short_url: short_url)
      end
      full_url = request.base_url + "/" + short_url
    end

    @url = Url.new(
      short_url: short_url,
      long_url: params[:long_url],
      full_url: full_url,
    )

    if @url.save
      render json: @url, status: :created
    else
      render status: :unprocessable_entity
    end
  end

  def long_url_redirect
    long_url = Url.find_by(short_url: params[:short_url]).long_url

    redirect_to long_url, status: :moved_permanently, allow_other_host: true
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
