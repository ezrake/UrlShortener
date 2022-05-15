class UrlsController < ApplicationController
  before_action :enough_short_urls, only: [:create]

  SHORT_URL_LIST = "short_urls"
  MIN_UNIQUE_IDS = 500

  def show
    @url = Url.find(params[:id])
  end

  def new
    @url = Url.new
  end

  def create
    if !params[:url][:short_url].empty?
      short_url = params[:url][:short_url]
    else
      while true
        short_url = fetch_redis_shorturl
        break if !Url.find_by(short_url: short_url)
      end
    end

    full_url = request.base_url + "/" + short_url
    @url = Url.new(
      short_url: short_url,
      long_url: params[:url][:long_url],
      full_url: full_url,
    )

    if @url.save
      flash[:success] = "Short url successfully created"
      redirect_to url_path(@url)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def long_url_redirect
    begin
      @url = Url.find_by!(short_url: params[:short_url])
    rescue ActiveRecord::RecordNotFound
      render :file => "public/404.html", status: :not_found and return
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
    params.require(:url).permit(:long_url, :short_url)
  end
end
