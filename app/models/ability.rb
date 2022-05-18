# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    can :read, [Product]

    if user&.admin == false
      can %i(update read), User, id: user.id
      can %i(read create update order_product), Order
    end

    can :manage, :all if user&.admin?
  end
end
