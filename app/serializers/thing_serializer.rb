class ThingSerializer < ActiveModel::Serializer
  attributes :properties

  def id
    object.sha
  end

  def properties
    object.properties.each do |key, values|
      values.merge!('units' => object.property_unit_for(key))
    end
  end

  link(:self)  { api_list_thing_path(object.list.sha, object.sha) }
  link(:list)  { api_list_path(object.list.sha) }
end
