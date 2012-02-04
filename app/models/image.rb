class Image < ActiveRecord::Base
  # Includes
  mount_uploader :image, ImageUploader

  # Before, after callbacks

  # Default scopes, default values (e.g. self.per_page =)

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  belongs_to :post

  # Validations: presence > by type > validates

  # Other properties (e.g. accepts_nested_attributes_for)

  # Model dictionaries, state machine

  # Scopes
  class << self
  end

  # Other model methods
  def to_param
    "#{self.id}-#{self.category.title.parameterize}-#{self.title.parameterize}"
  end

  # Private methods (for example: custom validators)
  private

end
