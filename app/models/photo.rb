class Photo < ActiveRecord::Base
  mount_uploader :asset, ImageUploader

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    'public/uploads'
  end

  OWNER_TYPES = %w[Project] # Event

  belongs_to :owner, polymorphic: true, touch: true

  validates :owner_type, inclusion: {in: Photo::OWNER_TYPES}
  validates_presence_of :owner_id, :owner_type

  scope :ordered, -> { order('photos.is_cover DESC, photos.weight DESC, photos.created_at ASC') }
end
