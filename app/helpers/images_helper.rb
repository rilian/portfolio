module ImagesHelper
  def render_image_data(image)
    data = ''
    if image.desc.present?
      data << ', ' if data.length > 0
      data << image.desc
    end
    if image.place.present?
      data << ', ' if data.length > 0
      data << image.place
    end
    if image.date.present?
      data << ', ' if data.length > 0
      data << image.date.strftime("%Y")
    end
    data
  end
end
