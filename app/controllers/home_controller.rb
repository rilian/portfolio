class HomeController < ApplicationController
  def index
    @image = Image.where(id: ENV['TITLE_IMAGE_ID']) if ENV['TITLE_IMAGE_ID'].present?
    album = Album.all.order("title='Portrait'").first
    @link = album_path(album) if album

    render layout: nil
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
