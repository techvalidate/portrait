class UserPresenter
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def print_groups
    user.groups.map(&:name).join(', ')
  end

  def print_roles
    user.roles.map(&:name).join(', ')
  end

  def method_missing(name, *args, &block)
    user.send(name, *args, &block)
  end
end
