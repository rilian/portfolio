class Collection < ActiveRecord::Base
  # Includes

  # Before, after callbacks

  # Default scopes, default values (e.g. self.per_page =)
  TYPES = %w[Album]

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  has_many :images, dependent: :destroy

  # Validations: presence > by type > validates
  validates_presence_of :title
  validates_uniqueness_of :title
  #TODO: validate type by TYPE

  # Other properties (e.g. accepts_nested_attributes_for)
  attr_accessible :type, :title, :is_hidden, :weight, :is_upload_to_stock, :description

  # Model dictionaries, state machine

  # Scopes
  default_scope order: 'collections.weight DESC'

  class << self
  end

  # Other model methods
  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  ##
  # Returns item label in select
  #
  def to_label
    "[#{self.type}] #{self.title}"
  end

  # Private methods (for example: custom validators)
  private
end
