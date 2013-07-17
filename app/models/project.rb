class Project < ActiveRecord::Base
  # Includes
  include RssRecordTouch

  # Before, after callbacks

  # Default scopes, default values (e.g. self.per_page =)
  PER_PAGE = 25

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  has_many :photos, as: :owner, dependent: :destroy

  # Validations: presence > by type > validates
  validates_presence_of :title, :info, :description
  validates_uniqueness_of :title, :title_ua

  # Other properties (e.g. accepts_nested_attributes_for)
  attr_accessible :title, :title_ua, :is_published, :description, :description_ua, :weight, :info, :info_ua,
                  :photos_attributes

  accepts_nested_attributes_for :photos, :allow_destroy => true, reject_if: proc { |a| !a.has_key?('id') && !a.has_key?('asset') }

  # Model dictionaries, state machine

  # Scopes

  scope :recent, ->() { includes(:photos).where(Project.arel_table[:updated_at].gt(Time.now - 1.day).or(Photo.arel_table[:updated_at].gt(Time.now - 1.day))).limit(1) }

  class << self
  end

  # Other model methods
  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

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

  def is_recent?
    Project.where(id: self.id).recent.size > 0
  end

  # Private methods (for example: custom validators)
  private

end
