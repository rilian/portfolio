class Project < ActiveRecord::Base
  # Includes

  # Before, after callbacks
  after_create :update_rss_record, if: Proc.new { |p| p.is_published? }
  after_update :update_rss_record, if: Proc.new { |p| !p.is_published_was && p.is_published? }

  # Default scopes, default values (e.g. self.per_page =)
  PER_PAGE = 50

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  has_many :photos, as: :owner, dependent: :destroy

  # Validations: presence > by type > validates
  validates_presence_of :title, :info, :description

  # Other properties (e.g. accepts_nested_attributes_for)
  attr_accessible :title, :is_published, :description, :weight, :info, :photos_attributes

  accepts_nested_attributes_for :photos, :allow_destroy => true, reject_if: proc { |a| !a.has_key?('id') && !a.has_key?('asset') }

  # Model dictionaries, state machine

  # Scopes

  class << self
  end

  # Other model methods

  ##
  # Get first cover photo of a project
  #
  # Returns {Photo}
  #
  def cover_photo
    cover_photo = self.photos.where(is_cover: true).order('photos.created_at ASC').first
    unless cover_photo
      cover_photo = self.photos.order('photos.created_at ASC').first
    end
    cover_photo
  end

  # Private methods (for example: custom validators)
  private

  def update_rss_record
    rss_record = RssRecord.where(owner_type: self.class.to_s, owner_id: self.id).first
    unless rss_record
      RssRecord.create(owner_type: self.class.to_s, owner_id: self.id)
    else
      rss_record.touch
    end
  end
end
