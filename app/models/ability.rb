class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, Page do |page|
      user.admin?(page.wiki)
    end
    can :manage, Wiki do |wiki|
      user.admin?(wiki)
    end
    can :manage, Attachment do |attachment|
      user.admin?(attachment.wiki)
    end
    can :manage, Collaboration do |collaboration|
      user.admin?(collaboration.wiki)
    end

    can :read, Page do |page|
      page.public?
    end
    can :read, Wiki do |wiki|
      wiki.public?
    end
    can :read, Attachment do |attachment|
      attachment.wiki.public?
    end
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
