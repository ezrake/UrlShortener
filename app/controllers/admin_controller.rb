class AdminController < ApplicationController
  before_action :authenticate_admin!

  def index
    @urls = Url.page(params[:page])
    render "admin/index"
  end

  def show_url
    @url = Url.find(params[:id])
    @click_stats = @url.click_stats.group(:user_agent).count(:clicks)
    render "admin/show"
  end
end
