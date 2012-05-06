xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Portfolio"
    xml.description "Portfolio"
    xml.link root_url

    @images.each do |image|
      xml.item do
        xml.title (image.title? ? image.title : 'Untitled')
        xml.description feed_item(image)
        xml.pubDate image.created_at.to_s(:rfc822)
        xml.link root_url
        xml.guid root_url
      end
    end
  end
end