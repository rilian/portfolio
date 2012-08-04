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

  DEFAULT_QUERY = 'title_or_desc_or_tags_cache_or_place_or_album_title_cont'

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  belongs_to :album

  # Validations: presence > by type > validates
  validates_presence_of :asset, :album, :title

  # Other properties (e.g. accepts_nested_attributes_for)
  attr_accessible :asset, :asset_cache, :album_id, :title, :desc, :place, :date,
                  :published_at_checkbox, :uploaded_to_flickr_at_checkbox, :tags, :tags_resolved,
                  :uploaded_to_flickr_at, :flickr_photo_id, :deviantart_id, :updated_at
  attr_taggable :tags

  # Model dictionaries, state machine

  # Scopes
  default_scope :order => "images.published_at DESC, images.created_at DESC"

  class << self
    def published
      self.where("images.published_at IS NOT NULL")
    end
    def not_from_hidden_album
      self.joins(:album).where("albums.is_hidden = ?", false)
    end
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

  def uploaded_to_flickr_at_checkbox
    self.uploaded_to_flickr_at.present?
  end

  def uploaded_to_flickr_at_checkbox=(val)
    self.uploaded_to_flickr_at = set_time(self.uploaded_to_flickr_at, val)
  end

  def tags_resolved
    self.tags * ', '
  end

  def tags_resolved=(value)
    self.tags = value if value.present?
  end

  def render_data
    data = ''
    [self.desc, self.place, self.date.try(:strftime, "%Y")].each do |text|
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
    initial_value = (checkbox_value == '1' && initial_value.blank?) ? Time.now : (checkbox_value != '1') ? nil : initial_value
  end
end
