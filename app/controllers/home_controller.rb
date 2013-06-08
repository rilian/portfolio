class HomeController < ApplicationController
  def index
    @q = Image.published.not_from_hidden_collection.includes([:taggings, :tags]).search(params[:q])
    @images = @q.result(distinct: true).page(params[:page]).per(Image::PER_PAGE)

    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end
end
