class Thing < ApplicationRecord
  belongs_to :list
  before_create :set_sha, :validate_properties

  def to_param
    sha
  end

private

  # TODO: Check that the properties we're trying to assign for each Thing are a
  # subset of the list-level properties defined.
  #
  # Returns a boolean
  def validate_properties
    true
  end

  def set_sha
    self.sha = SecureRandom.hex
  end
end
