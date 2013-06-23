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

  PER_PAGE = 50

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  belongs_to :collection

  # Validations: presence > by type > validates
  validates_presence_of :asset, :collection

  # Other properties (e.g. accepts_nested_attributes_for)
  attr_accessible :asset, :asset_cache, :collection_id, :desc, :image_width, :image_height

  # Model dictionaries, state machine

  # Scopes
  default_scope order: 'photos.weight DESC, photos.created_at ASC'

  class << self
  end

  # Other model methods

  # Private methods (for example: custom validators)
  private

end
