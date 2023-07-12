class Ability
  include CanCan::Ability

  def initialize user
    can :read, Tour

    return if user.blank?

    can :read, User, id: user.id
    can [:read, :create, :update], Order

    return unless user.admin?

    can :read, :all
    can [:create, :update], Tour
    can :update, Order
  end
end
