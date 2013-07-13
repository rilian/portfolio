class HomeController < ApplicationController
  def index
    @q = Image.from_published_album.published.includes([:taggings, :tags]).search(params[:q])
    @images = @q.result(distinct: true).page(params[:page]).per(Image::PER_PAGE)
  end

  def contacts
  end

  def rss
    @rss_records = RssRecord.order('updated_at DESC').limit(20)

    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end
