require 'portfolio/rss_record_touch'

class Project < ActiveRecord::Base
  include Portfolio::RssRecordTouch

  self.inheritance_column = nil

  has_many :photos, as: :owner, dependent: :destroy

  TYPES = %w[project publication]

  validates :title, :info, :description, presence: true
  validates :title, :title_ua, uniqueness: true
  validates :type, inclusion: { in: TYPES }

  accepts_nested_attributes_for :photos, allow_destroy: true, reject_if: proc { |a| !a.has_key?('id') && !a.has_key?('asset') }

  scope :recent, -> {
    includes(:photos).
      where(Project.arel_table[:created_at].gt(Time.now - 1.day).or(
              Photo.arel_table[:created_at].gt(Time.now - 1.day)))
  }

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  # Get first cover photo of a project
  # Returns {Photo}
  def cover_photo
    self.photos.where(is_cover: true).ordered.first || self.photos.ordered.first
  end

  def is_recent?
    Project.where(id: self.id).recent.exists?
  end
end
