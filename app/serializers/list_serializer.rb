class ListSerializer < ActiveModel::Serializer
  attributes :name, :description, :properties

  def id
    object.sha
  end

  link(:self)   { api_list_path(object.sha) }
  link(:things) { api_list_things_path(object.sha) }

  has_many :things
end
