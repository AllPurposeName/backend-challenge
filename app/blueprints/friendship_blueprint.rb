class FriendshipBlueprint < Blueprinter::Base
  identifier :id
  association :friend, blueprint: UserBlueprint, view: :compact
  association :user, blueprint: UserBlueprint, view: :compact
end

