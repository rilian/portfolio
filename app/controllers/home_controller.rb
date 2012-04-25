class HomeController < ApplicationController
  def index
    @q = Image.includes([:category]).search(params[:q])
    @images = @q.result(:distinct => true).page(params[:page]).per(10)
  end

  def contacts
  end
end
