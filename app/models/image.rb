class Image < ActiveRecord::Base
  # Includes
  mount_uploader :asset, ImageUploader

  # Before, after callbacks
  before_save :update_values

  # Default scopes, default values (e.g. self.per_page =)
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    'public/uploads'
  end

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  belongs_to :album

  # Validations: presence > by type > validates
  validates_presence_of :asset, :album, :title

  # Other properties (e.g. accepts_nested_attributes_for)
  attr_accessible :asset, :asset_cache, :album_id, :title, :desc, :place, :date,
                  :published_at_checkbox, :uploaded_to_flickr_at_checkbox, :tags, :tags_resolved,
                  :uploaded_to_flickr_at, :flickr_photo_id
  attr_taggable :tags

  # Model dictionaries, state machine

  # Scopes
  default_scope :order => 'published_at DESC, created_at DESC'

  class << self
    def published
      self.where("published_at IS NOT NULL")
    end
  end

  # Other model methods
  def published_at_checkbox
    self.published_at.present?
  end

  def published_at_checkbox=(val)
    self.published_at = Time.now if val == '1' && self.published_at.blank?
    self.published_at = nil unless val == '1'
  end

  def uploaded_to_flickr_at_checkbox
    self.uploaded_to_flickr_at.present?
  end

  def uploaded_to_flickr_at_checkbox=(val)
    self.uploaded_to_flickr_at = Time.now if val == '1' && self.uploaded_to_flickr_at.blank?
    self.uploaded_to_flickr_at = nil unless val == '1'
  end

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  def tags_resolved
    self.tags * ', '
  end

  def tags_resolved=(value)
    self.tags = value if value.present?
  end

  def render_data
    data = ''
    if self.desc.present?
      data << ', ' if data.length > 0
      data << self.desc
    end
    if self.place.present?
      data << ', ' if data.length > 0
      data << self.place
    end
    if self.date.present?
      data << ', ' if data.length > 0
      data << self.date.strftime("%Y")
    end
    data
  end

  # Private methods (for example: custom validators)
  private

  def update_values
    self.tags_cache = self.tags_resolved
    self.title = self.title.titleize
    self.desc = self.desc.try(:capitalize)
    self.place = self.place.try(:capitalize)
  end
end
