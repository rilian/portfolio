class Project < ActiveRecord::Base
  # Includes

  # Before, after callbacks

  # Default scopes, default values (e.g. self.per_page =)

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  has_many :photos, as: :owner, dependent: :destroy

  # Validations: presence > by type > validates

  # Other properties (e.g. accepts_nested_attributes_for)

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
end
