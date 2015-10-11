class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, :all
    else
      can :read, Album, is_published: true
      can :read, Project, is_published: true
    end
  end
end
