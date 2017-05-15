class ListSerializer < ActiveModel::Serializer
  attributes :sha, :name, :description, :properties

  def id
    object.sha
  end

  has_many :things
end
