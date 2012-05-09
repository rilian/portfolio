class Image < ActiveRecord::Base
  # Includes
  mount_uploader :asset, ImageUploader

  # Before, after callbacks

  # Default scopes, default values (e.g. self.per_page =)

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  belongs_to :album

  # Validations: presence > by type > validates
  validates_presence_of :asset, :album

  # Other properties (e.g. accepts_nested_attributes_for)
  attr_accessible :asset, :asset_cache, :album_id, :title, :desc, :place, :date, :is_vertical, :published_at_checkbox

  # Model dictionaries, state machine

  # Scopes
  default_scope :order => 'published_at DESC'

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
    self.published_at = (val == '1' ? Time.now : nil)
  end

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  # Private methods (for example: custom validators)
  private

end
