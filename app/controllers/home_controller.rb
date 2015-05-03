class HomeController < ApplicationController
  def index
    if params[:q] && params[:q].has_key?('anything_like')
      params[:q][Image::DEFAULT_QUERY.to_sym] = params[:q].delete('anything_like')
    end

    @q = Image.from_published_albums.published

    portrait_album = Album.where(title: 'Portrait').first
    @q = @q.where(album_id: portrait_album.id) if portrait_album

    @q = @q.sorted.includes([:image_tags, :tags]).search(params[:q])

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
