module ApplicationHelper
  ##
  # Returns array of weighted tags, extracted from all Image
  #
  def get_tags_cloud(images)
    tags_cloud = Hash.new(0)
    images.map(&:tags).flatten.each { |tag| tags_cloud[tag] += 1 }
    tags_cloud.sort_by { rand }
  end

  ##
  # Loads setting from database
  #
  def get_setting(field)
    setting = Setting.where(env: Rails.env).first
    raise 'Setting not found' unless setting
    setting.send(field.to_sym)
  end

  ##
  # Return value by current ocation, or any other existing value
  #
  def get_local_value(current_locale, value_hash)
    return value_hash[current_locale.to_sym] if value_hash[current_locale.to_sym].present?
    value_hash.values.select{|v| v.present?}.first
  end

  def render_image_data(current_locale, image)
    data = ''
    desc = get_local_value(current_locale, {en: image.desc, ua: image.desc_ua})
    place = get_local_value(current_locale, {en: image.place, ua: image.place_ua})

    [desc, place, image.date.try(:strftime, '%Y')].each do |text|
      unless text.nil? || text.empty?
        data << '. ' if data.length > 0
        data << text
      end
    end
    data
  end

  ##
  # Replace urls with links
  #
  def highlight_links(text)
    text = '' if text.nil?
    begin
      new_text = text.dup
      while new_text =~ /([\s\r\n]+|^)[^"]*(http[s]{0,1}:\/\/[^\s\r\n<]*)/u
        link = $2
        new_text.gsub!(link, "<a href=\"#{link}\" rel=\"nofollow\" target=\"_blank\">#{link}</a>")
      end
      new_text
    rescue
      text
    end
  end
end
