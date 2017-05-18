class Thing < ApplicationRecord
  belongs_to :list
  before_create :set_sha
  validate :property_checks

  def to_param
    sha
  end

  def property_value_for(list_property_key)
    if property = properties.select { |p| p['property_key'] == list_property_key }
      return property.first['property_value']
    else
      return ""
    end
  end

  def property_keys
    @property_keys ||= properties.nil? ? [] : properties.collect { |p| p['property_key']}
  end

  def property_values
    @property_values ||= properties.nil? ? [] : properties.collect { |p| p['property_value']}
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
  # subset of the list-level properties defined. All Thing properties can have
  # an 'origin' field.
  #
  def property_checks
    errors.add(:base, "You can't have a Thing without properties") if property_keys.empty?

    self.property_keys.each do |key|
      errors.add(:properties, "'#{key}' is an invalid property for this List") unless available_property_keys.include?(key)
    end
  end

  def set_sha
    self.sha = SecureRandom.hex
  end
end
