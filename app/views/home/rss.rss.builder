xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title get_setting('title')
    xml.description { xml.cdata!(get_setting('description')) }
    xml.link rss_feed_url

    @rss_records.each do |rss_record|
      if rss_record.owner
        xml.item do
          xml.title { xml.cdata!(get_local_value(I18n.locale, {en: rss_record.owner.title, ru: rss_record.owner.title_ru})) }
          xml.description { xml.cdata!((render "#{rss_record.owner_type.underscore.pluralize}/#{rss_record.owner_type.underscore}", rss_record.owner_type.underscore.to_sym => rss_record.owner).html_safe) }
          xml.pubDate rss_record.owner.created_at.to_s(:rfc822)
          xml.link send("#{rss_record.owner_type.underscore}_url".to_sym, rss_record.owner)
          xml.guid send("#{rss_record.owner_type.underscore}_url".to_sym, rss_record.owner)
        end
      end
    end
  end
end
