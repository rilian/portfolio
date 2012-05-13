xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Portfolio"
    xml.description { xml.cdata!("Portfolio Works") }
    xml.link rss_feed_url

    @images.each do |image|
      xml.item do
        xml.title { xml.cdata!(image.title) }
        xml.description { xml.cdata!((render 'images/image', :image => image).html_safe) }
        xml.pubDate image.created_at.to_s(:rfc822)
        xml.link image_url(image)
        xml.guid image_url(image)
      end
    end
  end
end