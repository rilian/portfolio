class Photo < ActiveRecord::Base
  # Includes
  mount_uploader :asset, ImageUploader

  # Before, after callbacks

  # Default scopes, default values (e.g. self.per_page =)
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    'public/uploads'
  end

  OWNER_TYPES = %w[Project] # Event

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  belongs_to :owner, polymorphic: true, touch: true

  # Validations: presence > by type > validates
  validates :owner_type, inclusion: {in: Photo::OWNER_TYPES}
  validates_presence_of :asset, :owner_id, :owner_type

  # Other properties (e.g. accepts_nested_attributes_for)

  # Model dictionaries, state machine

  # Scopes

  scope :ordered, -> { order('photos.is_cover DESC, photos.weight DESC, photos.created_at ASC') }

  # Other model methods

  # Private methods (for example: custom validators)
  private

end
