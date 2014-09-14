require 'portfolio/rss_record_touch'

class Image < ActiveRecord::Base
  # Includes
  mount_uploader :asset, ImageUploader
  include Portfolio::RssRecordTouch

  # Before, after callbacks
  before_save :update_values

  # Default scopes, default values (e.g. self.per_page =)
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    'public/uploads'
  end

  DEFAULT_QUERY = 'title_or_desc_or_tags_cache_or_place_or_album_title_cont'
  TITLE_MIN_FOR_SALE = 7
  TITLE_MIN = 4
  DESC_MIN_FOR_SALE = 30
  DESC_MIN = 15
  TAGS_MIN_FOR_SALE = 30
  TAGS_MIN = 10

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  belongs_to :album, touch: true
  has_many :image_tags
  has_many :tags, through: :image_tags

  # Validations: presence > by type > validates
  validates_presence_of :album, :title

  # Other properties (e.g. accepts_nested_attributes_for)

  # Model dictionaries, state machine

  # Scopes
  scope :sorted, -> { order('images.published_at DESC, images.created_at DESC') }
  scope :published, -> { where('images.published_at IS NOT NULL') }
  scope :from_published_albums, -> { joins(:album).where('(albums.is_published = ? AND albums.is_upload_to_stock = ?)', true, true) }

  # Other model methods

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  def published_at_checkbox
    self.published_at.present?
  end

  def published_at_checkbox=(val)
    self.published_at = set_time(self.published_at, val)
  end

  def tags_resolved
    self.tags.map(&:name) * ', '
  end

  def tags_resolved=(names)
    tags_arr = []
    names.split(', ').uniq.each do |name|
      tag = Tag.where(name: name.strip).first_or_create
      ImageTag.where(image: self, tag: tag).first_or_create
      tags_arr << tag
    end
    update_values
  end

  # Private methods (for example: custom validators)
  private

  def update_values
    self.tags_cache = self.tags_resolved
  end

  def set_time(initial_value, checkbox_value)
    if checkbox_value == '1' && initial_value.blank?
      Time.now
    else
      (checkbox_value != '1') ? nil : initial_value
    end
  end

  protected

  def is_published_changed?
    self.published_at_changed?
  end

  def is_published?
    self.published_at.present?
  end
end
