class HomeController < ApplicationController
  def index
    @image = Image.find(ENV['TITLE_IMAGE_ID'])
    @link = album_path(Album.all.order("title='Portrait'").first)

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
