xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title get_setting('title')
    xml.description { xml.cdata!(get_setting('description')) }
    xml.link rss_feed_url

    @rss_records.each do |rss_record|
      if rss_record.owner
        xml.item do
          xml.title { xml.cdata!(rss_record.owner.title) }

          case rss_record.owner_type
            when 'Image'
              xml.description { xml.cdata!((render 'images/image', image: rss_record.owner).html_safe) }
              xml.pubDate rss_record.owner.created_at.to_s(:rfc822)
              xml.link image_url(rss_record.owner)
              xml.guid image_url(rss_record.owner)
            when 'Project'
              xml.description { xml.cdata!(rss_record.owner.info) }
              xml.pubDate rss_record.owner.created_at.to_s(:rfc822)
              xml.link project_url(rss_record.owner)
              xml.guid project_url(rss_record.owner)
          end
        end
      end
    end
  end
end
