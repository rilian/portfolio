class Album < ActiveRecord::Base
  has_many :images, dependent: :destroy

  validates_presence_of :title
  validates_uniqueness_of :title

  scope :by_weight, ->() { order('"albums"."weight" DESC') }
  scope :published, -> { where(is_published: true) }
  scope :recent, -> { joins(:images).where(Image.arel_table[:created_at].gt(Time.now - 1.day)).limit(1) }

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  def is_recent?
    Album.where(id: self.id).recent.size > 0
  end
end
