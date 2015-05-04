# encoding: UTF-8

module ImageHelper
  def check_title(image)
    get_notice(image.title, Image::TITLE_MIN, 'words')
  end

  def check_desc(image)
    get_notice(render_image_data(I18n.locale, image), Image::DESC_MIN, 'words')
  end

  def check_tags(image)
    get_notice(image.tags_resolved, Image::TAGS_MIN, 'tags')
  end

  private

  def get_notice(str, need_words, object_names)
    if str.scan(/\w+/u).size < need_words
      "<span class=\"label label-important\">need #{need_words} #{object_names}</span>".html_safe
    end
  end
end
