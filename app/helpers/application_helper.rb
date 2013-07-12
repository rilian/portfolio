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
end
