module ImagesHelper
  def render_image_data(image)
    data = ''
    if image.title
      data << "<strong>#{image.title}</strong>"
      data = data.html_safe
    end
    if image.desc
      data << ', ' if data.length > 0
      data << image.desc
    end
    if image.place
      data << ', ' if data.length > 0
      data << image.place
    end
    if image.date
      data << ', ' if data.length > 0
      data << image.date.strftime("%Y")
    end
  end
end
