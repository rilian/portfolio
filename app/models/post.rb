class Post < ActiveRecord::Base
  # Includes

  # Before, after callbacks

  # Default scopes, default values (e.g. self.per_page =)

  # Associations: belongs_to > has_one > has_many > has_and_belongs_to_many
  belongs_to :category
  has_many :images

  # Validations: presence > by type > validates
  validates_presence_of :title

  # Other properties (e.g. accepts_nested_attributes_for)
  accepts_nested_attributes_for :images, :allow_destroy => true

  # Model dictionaries, state machine

  # Scopes
  class << self
    def published
      self.where(:is_published => true)
    end
  end

  # Other model methods

  # Private methods (for example: custom validators)
  private
end
