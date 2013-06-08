module ApplicationHelper
  ##
  # Returns array of weighted tags, extracted from all Image
  #
  def get_tags_cloud
    tags_cloud = Hash.new(0)
    Image.published.limit(50).map(&:tags).flatten.each { |tag| tags_cloud[tag] += 1 }
    tags_cloud.sort_by { rand }
  end
end
