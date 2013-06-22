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

  DEFAULT_QUERY = 'title_or_desc_or_tags_cache_or_place_or_collection_title_cont'
  TITLE_MIN_FOR_SALE = 7
  TITLE_MIN = 4
  DESC_MIN_FOR_SALE = 30
  DESC_MIN = 15
  TAGS_MIN_FOR_SALE = 30
  TAGS_MIN = 10

  PER_PAGE = 25

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  belongs_to :collection

  # Validations: presence > by type > validates
  validates_presence_of :asset, :collection, :title
  validates_numericality_of :flickr_photo_id, if: Proc.new { |i| i.flickr_photo_id.present? }

  # Other properties (e.g. accepts_nested_attributes_for)
  attr_accessible :asset, :asset_cache, :collection_id, :title, :desc, :place, :date, :updated_at,
                  :published_at_checkbox, :tags, :tags_resolved, :flickr_photo_id, :flickr_comment_time,
                  :deviantart_link, :istockphoto_link, :shutterstock_link,
                  :is_for_sale, :image_width, :image_height
  attr_taggable :tags

  # Model dictionaries, state machine

  # Scopes
  default_scope order: 'images.published_at DESC, images.created_at DESC'

  scope :published, ->() { where('images.published_at IS NOT NULL') }

  scope :not_from_hidden_collection, ->() { joins(:collection).where('(collections.is_hidden = ? AND collections.is_upload_to_stock = ?)', false, true) }

  class << self
  end

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
    self.tags * ', '
  end

  def tags_resolved=(value)
    self.tags = value if value.present?
  end

  def render_data
    data = ''
    [self.desc, self.place, self.date.try(:strftime, '%Y')].each do |text|
      unless text.empty?
        data << '. ' if data.length > 0
        data << text
      end
    end
    data
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
end
