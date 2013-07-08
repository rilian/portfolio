class Ability
  include CanCan::Ability

  def initialize(user)
    # Guests have no abilities
    if user
      can :manage, :all
    else
      can :read, Album
      can :read, Project
    end
  end
end
