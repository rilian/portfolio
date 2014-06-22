class ::ImageTag < ActiveRecord::Base
  belongs_to :image
  belongs_to :tag

  validates_uniqueness_of :image_id, scope: :tag_id
end
