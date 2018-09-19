class List < ApplicationRecord
  belongs_to :user
  has_many :things, dependent: :destroy
  before_create :set_sha
  before_save :set_property_keys
  validate :property_checks

  # Minimal required fields for new properties
  REQUIRED_PROPERTY_FIELDS = %w{
    name
    group
  }.freeze

  default_scope  { order(:created_at => :desc) }
  scope :visible, -> { where(:visible => true) }
  scope :hidden, -> { where(:visible => false) }
  scope :visible_to_user, ->(user) { where(:user_id => user.id).or(visible) }

  # Add a new propery to the List properties array
  # Attempts to save the list (triggering validations on required fields)
  def add_property!(property)
    current_properties = properties || []
    current_properties << property if valid_property?(property)
    update_attributes(:properties => current_properties)
  end

  # Takes a sanitized list of key:value pairs from the controller to query List
  # Things on.
  #
  # Returns an ActiveRecord::AssociationRelation
  def filter_things_with(query_string)
    return self.things if query_string.empty?

    scoped_things = self.things

    # Loop through the query_string building a query as we go...
    query_string.each do |query_key, query_value|
      if query_value.start_with?('gte')
        value = query_value.gsub(/^gte/, '')
        scoped_things = scoped_things.where("properties -> '#{query_key}' ->> 'value' >= ?", value)
      elsif query_value.start_with?('lte')
        value = query_value.gsub(/^lte/, '')
        scoped_things = scoped_things.where("properties -> '#{query_key}' ->> 'value' <= ?", value)
      else
        scoped_things = scoped_things.where("properties -> '#{query_key}' ->> 'value' = ?", query_value)
      end
    end

    return scoped_things
  end

  def grouped_properties
    properties.group_by {|p| p['group']}
  end

  # TODO: Check that we're not adding duplicates etc.
  def valid_property?(property)
    true
  end

  def property_for(property_key)
    properties.select { |p| p['key'] == property_key }.first
  end

  def property_units_for(property_key)
    if property = property_for(property_key)
      return property['units']
    else
      return nil
    end
  end

  # default_name,default_star_name,orbital_parameters_planet_mass,default_ra,default_dec
  def to_csv
    CSV.generate do |csv|
      csv << property_index_keys
      things.each do |thing|
        vals = []
        property_index_keys.each do |key|
          vals << thing.property_value_for(key)
        end

        csv << vals
      end
    end
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

  def property_index_keys
    properties.map { |property| property['key'] }.uniq
  end

  def owner
    user
  end

  def hidden?
    !visible?
  end

private

  # TODO: Do whatever sanity checks we want to on the list properties here. For
  # example, we might want to limit the number of properties a user can define
  # for a list
  #
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
      next if property['key'] # don't set the key if it already exists
      property['key'] = "#{property['group']} #{property['name']}".underscore.parameterize(separator: "_")
    end
  end

  def set_sha
    self.sha = SecureRandom.hex
  end
end
