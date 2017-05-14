class Thing < ApplicationRecord
  belongs_to :list
  before_create :set_sha
  validate :property_checks

  def to_param
    sha
  end

  def property_keys
    properties.keys
  end

  def property_values
    properties.values
  end

  # Things inherit their properties from their parent List
  #
  # Returns hash of properties
  def available_properties
    @properties ||= list.properties
  end

  def available_property_keys
    @keys ||= list.properties.map { |property| property['key']}
  end

private

  # TODO: Check that the properties we're trying to assign for each Thing are a
  # subset of the list-level properties defined.
  #
  # Returns a boolean
  def property_checks
    true
  end

  def set_sha
    self.sha = SecureRandom.hex
  end
end
