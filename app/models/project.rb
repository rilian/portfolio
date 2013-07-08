class Project < ActiveRecord::Base
  # Includes

  # Before, after callbacks

  # Default scopes, default values (e.g. self.per_page =)

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  has_many :photos, dependent: :destroy

  # Validations: presence > by type > validates

  # Other properties (e.g. accepts_nested_attributes_for)

  # Model dictionaries, state machine

  # Scopes

  class << self
  end

  # Other model methods

  def cover_photo
    nil
  end

  # Private methods (for example: custom validators)
  private
end
