class Project < ActiveRecord::Base
  # Includes
  include RssRecordTouch

  # Before, after callbacks

  # Default scopes, default values (e.g. self.per_page =)

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  has_many :photos, as: :owner, dependent: :destroy

  # Validations: presence > by type > validates
  validates_presence_of :title, :info, :description
  validates_uniqueness_of :title, :title_ua

  # Other properties (e.g. accepts_nested_attributes_for)

  accepts_nested_attributes_for :photos, allow_destroy: true, reject_if: proc { |a| !a.has_key?('id') && !a.has_key?('asset') }

  # Model dictionaries, state machine

  # Scopes

  scope :recent, -> {
    includes(:photos).
      where(Project.arel_table[:created_at].gt(Time.now - 1.day).or(
              Photo.arel_table[:created_at].gt(Time.now - 1.day)))
  }

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
    self.photos.where(is_cover: true).ordered.first || self.photos.ordered.first
  end

  def is_recent?
    Project.where(id: self.id).recent.exists?
  end

  # Private methods (for example: custom validators)
  private

end
