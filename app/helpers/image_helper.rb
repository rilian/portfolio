module ImageHelper
  def check_title(image)
    if image.title.scan(/\w+/).size < (image.is_for_sale? ? Image::TITLE_MIN_FOR_SALE : Image::TITLE_MIN)
      "<span class=\"label label-important\">need #{image.is_for_sale? ? Image::TITLE_MIN_FOR_SALE : Image::TITLE_MIN} words</span>".html_safe
    end
  end

  def check_desc(image)
    if image.render_data.scan(/\w+/).size < (image.is_for_sale? ? Image::DESC_MIN_FOR_SALE : Image::DESC_MIN)
      "<span class=\"label label-important\">need #{image.is_for_sale? ? Image::DESC_MIN_FOR_SALE : Image::DESC_MIN} words</span>".html_safe
    end
  end

  def check_tags(image)
    if image.tags_resolved.scan(/\w+/).size < (image.is_for_sale? ? Image::TAGS_MIN_FOR_SALE : Image::TAGS_MIN)
      "<span class=\"label label-important\">need #{image.is_for_sale? ? Image::TAGS_MIN_FOR_SALE : Image::TAGS_MIN} tags</span>".html_safe
    end
  end
end
