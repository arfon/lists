class ThingSerializer < ActiveModel::Serializer
  attributes :properties

  def id
    object.sha
  end

  link(:self)  { list_thing_path(object.list.sha, object.sha) }
  link(:list)  { list_path(object.list.sha) }
end
