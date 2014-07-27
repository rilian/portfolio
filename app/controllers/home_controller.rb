class HomeController < ApplicationController
  def index
    if params[:q] && params[:q].has_key?('anything_like')
      params[:q][Image::DEFAULT_QUERY.to_sym] = params[:q].delete('anything_like')
    end

    @q = Image.from_published_albums.published.sorted.includes([:image_tags, :tags]).search(params[:q])
    @images = @q.result(distinct: true).page(params[:page])
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
