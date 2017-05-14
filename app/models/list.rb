class List < ApplicationRecord
  belongs_to :user
  before_create :set_sha
  before_save :set_property_keys
  validate :property_checks

  # Minimal required fields for new properties
  REQUIRED_PROPERTY_FIELDS = %w{
    name
    group
  }.freeze

  scope :visible, -> { where(:visible => true) }
  scope :hidden, -> { where(:visible => false) }

  # Add a new propery to the List properties array
  # Attempts to save the list (triggering validations on required fields)
  def add_property!(property)
    current_properties = properties || []
    current_properties << property if valid_property?(property)
    update_attributes(:properties => current_properties)
  end

  # TODO: Check that we're not adding duplicates etc.
  def valid_property?(property)
    true
  end

  def to_param
    sha
  end

  def property_groups
    properties.map { |property| property['group'] }.uniq
  end

  def property_keys
    properties.map { |property| property['name'] }.uniq
  end

private

  # TODO: Do whatever sanity checks we want to on the list properties here. For
  # example, we might want to limit the number of properties a user can define
  # for a list
  #
  # Returns a boolean
  def property_checks
    return unless properties
    properties.each do |property|
      REQUIRED_PROPERTY_FIELDS.each do |field|
        self.errors.add(:properties, "Property invalid. '#{field}' field is a missing") unless property.has_key?(field)
      end
    end
  end

  # When we save a List property we automatically set a unique property_key
  # value which is parameterize(separator: "_")
  def set_property_keys
    return unless properties
    properties.each do |property|
      property['key'] = "#{property['group']} #{property['name']}".underscore.parameterize(separator: "_")
    end
  end

  def set_sha
    self.sha = SecureRandom.hex
  end
end
