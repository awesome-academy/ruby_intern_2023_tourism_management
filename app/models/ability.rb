class Ability
  include CanCan::Ability

  def initialize user
    can :read, Tour
    can :read, Comment

    return if user.blank?

    can :read, User, id: user.id
    can [:read, :create, :update], Order
    can [:create, :update, :destroy], Comment

    return unless user.admin?

    can :read, :all
    can [:create, :update], Tour
    can :update, Order
  end
end
