class ThingSerializer < ActiveModel::Serializer
  attributes :properties

  def id
    object.sha
  end

  link(:self)  { api_list_thing_path(object.list.sha, object.sha) }
  link(:list)  { api_list_path(object.list.sha) }
end
