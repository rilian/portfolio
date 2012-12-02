class Album < ActiveRecord::Base
  # Includes

  # Before, after callbacks

  # Default scopes, default values (e.g. self.per_page =)

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  has_many :images, dependent: :destroy

  # Validations: presence > by type > validates
  validates_presence_of :title
  validates_uniqueness_of :title

  # Other properties (e.g. accepts_nested_attributes_for)

  # Model dictionaries, state machine

  # Scopes
  default_scope order: "albums.weight DESC"

  class << self
  end

  # Other model methods
  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  # Private methods (for example: custom validators)
  private
end
