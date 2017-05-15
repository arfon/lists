class ThingSerializer < ActiveModel::Serializer
  attributes :sha, :properties

  def id
    object.sha
  end
end
