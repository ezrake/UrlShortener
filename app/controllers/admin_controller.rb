class AdminController < ApplicationController
  before_action :authenticate_admin!

  def index
    @urls = Url.page(params[:page])
    render "admin/index"
  end

  def show_url
    @url = Url.find(params[:id])
    render "urls/show"
  end
end
