class UserSerializer < ActiveModel::Serializer
  attributes :name, :lists

  def id
    object.sha
  end

  link(:self)   { api_user_path(object.sha) }

  has_many :lists

  def lists
    object.lists.visible
  end
end
