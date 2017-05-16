class ThingPolicy
  attr_reader :user, :thing

  def initialize(user, thing)
    @user = user
    @thing = thing
  end

  def index?
    show?
  end

  def show?
    # Everyone can see a list if it's marked as 'visible'
    return true if thing.list.visible?

    # If it's not visible and there's no user then return false
    return false if thing.list.user.nil?

    if user && user == thing.list.owner
      return true
    else
      return false
    end
  end
end
