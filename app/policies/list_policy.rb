class ListPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.nil?
        scope.visible
      elsif user.admin?
        scope.all
      else
        scope.visible_to_user(user)
      end
    end
  end

  attr_reader :user, :list

  def initialize(user, list)
    @user = user
    @list = list
  end

  def show?
    # Everyone can see a list if it's marked as 'visible'
    return true if list.visible?

    # If it's not visible and there's no user then return false
    return false if user.nil?

    if user && user == list.owner
      return true
    else
      return false
    end
  end
end
