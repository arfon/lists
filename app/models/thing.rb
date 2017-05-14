class Thing < ApplicationRecord
  belongs_to :list
  before_create :set_sha
  validate :property_checks

  def to_param
    sha
  end

  def property_keys
    @property_keys ||= properties.nil? ? [] : properties.keys
  end

  def property_values
    @property_values ||= properties.nil? ? [] : properties.values
  end

  # Things inherit their properties from their parent List
  #
  # Returns array of properties
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
  def property_checks
    errors.add(:base, "You can't have a Thing without properties") if property_keys.empty?
  end

  def set_sha
    self.sha = SecureRandom.hex
  end
end
