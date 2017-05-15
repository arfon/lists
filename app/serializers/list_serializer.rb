class ListSerializer < ActiveModel::Serializer
  attributes :name, :description, :properties

  def id
    object.sha
  end

  link(:self)   { list_path(object.sha) }
  link(:things) { list_things_path(object.sha) }

  has_many :things
end
