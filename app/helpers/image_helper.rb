# encoding: UTF-8

module ImageHelper
  def check_title(image)
    get_notice(image.title, image.is_for_sale? ? Image::TITLE_MIN_FOR_SALE : Image::TITLE_MIN, 'words')
  end

  def check_desc(image)
    get_notice(render_image_data(I18n.locale, image), image.is_for_sale? ? Image::DESC_MIN_FOR_SALE : Image::DESC_MIN, 'words')
  end

  def check_tags(image)
    get_notice(image.tags_resolved, image.is_for_sale? ? Image::TAGS_MIN_FOR_SALE : Image::TAGS_MIN, 'tags')
  end

  ##
  # Replace urls with links
  #
  def highlight_links(text)
    text = '' if text.nil?
    begin
      new_text = text.dup
      while new_text =~ /([\s\r\n]+|^)(http:\/\/|https:\/\/|www.)([^\s\r\n]*\.[^\s\r\n]*)([\s\r\n]+|$)/su
        protocol = $2
        href = $3
        new_text.gsub!("#{protocol}#{href}", "<a href=\"#{protocol}#{href}\" rel=\"nofollow\" target=\"_blank\">#{protocol}#{href}</a>")
      end
      new_text
    rescue
      text
    end
  end

  private

  def get_notice(str, need_words, object_names)
    if str.scan(/\w+/u).size < need_words
      "<span class=\"label label-important\">need #{need_words} #{object_names}</span>".html_safe
    end
  end
end
